@** Annotations for Values.

\noindent In circumstances where a control setting is logged but this setting
changes infrequently and has a small number of possible values, it is sometimes
useful to not log the control values throughout the roast but rather simply add
an annotation when the control value changes. It will commonly be desirable to
also provide an annotation representing the current state at the start of every
batch.

To support this feature, there must be a configuration widget which can be used
to identify which data series should be monitored and what annotations should
be produced for what values.

@<Class declrations@>=
class ValueAnnotationConfWidget : public BasicDeviceConfigurationWidget
{
	Q_OBJECT
	public:
		Q_INVOKABLE ValueAnnotationConfWidget(DeviceTreeModel *model,
                                              const QModelIndex &index);
	private slots:
		void updateSourceColumn(const QString &source);
		void updateAnnotations();
		void updateStart(bool noteOnStart);
	private:
		SaltModel *model;
};

@ The constructor sets up the configuration interface requesting a source
column name, if an annotation should be emitted at the start of the batch, and
what annotations should be produced for what values.

@<ValueAnnotationConfWidget implementation@>=
ValueAnnotationConfWidget::ValueAnnotationConfWidget(DeviceTreeModel *model,
                                                     const QModelIndex &index)
: BasicDeviceConfigurationWidget(model, index),
  model(new SaltModel(2))
{
	QFormLayout *layout = new QFormLayout;
	QLineEdit *source = new QLineEdit;
	layout->addRow(tr("Source column name:"), source);
	QCheckBox *noteOnStart = new QCheckBox(tr("Produce Start State Annotation"));
	noteOnStart->setChecked(true);
	layout->addRow(noteOnStart);
	model->setHeaderData(0, Qt::Horizontal, "Value");
	model->setHeaderData(1, Qt::Horizontal, "Annotation");
	QTableView *annotationTable = new QTableView;
	annotationTable->setModel(model);
	NumericDelegate *delegate = new NumericDelegate;
	annotationTable->setItemDelegateForColumn(0, delegate);
	layout->addRow(tr("Annotations for values:"), annotationTable);
	@<Get device configuration data for current node@>=
	for(int i = 0; i < configData.size(); i++)
	{
		node = configData.at(i).toElement();
		if(node.attribute("name") == "source")
		{
			source->setText(node.attribute("value"));
		}
		else if(node.attribute("name") == "emitOnStart")
		{
			noteOnStart->setChecked(node.attribute("value") == "true" ? true : false);
		}
		else if(node.attribute("name") == "measuredValues")
		{
			@<Convert numeric array literal to list@>@;
			int column = 0;
			@<Populate model column from list@>@;
		}
		else if(node.attribute("name") == "annotations")
		{
			@<Convert numeric array literal to list@>@;
			int column = 1;
			@<Populate model column from list@>@;
		}
	}
	updateSourceColumn(source->text());
	updateStart(noteOnStart->isChecked());
	updateAnnotations();
	connect(source, SIGNAL(textEdited(QString)), this, SLOT(updateSourceColumn(QString)));
	connect(noteOnStart, SIGNAL(toggled(bool)), this, SLOT(updateStart(bool)));
	connect(model, SIGNAL(dataChanged(QModelIndex, QModelIndex)), this, SLOT(updateAnnotations()));
	setLayout(layout);
}

@ To update the table data, the measued values and annotations are saved in
separate lists.

@<ValueAnnotationConfWidget implementation@>=
void ValueAnnotationConfWidget::updateAnnotations()
{
	updateAttribute("measuredValues", model->arrayLiteral(0, Qt::DisplayRole));
	updateAttribute("annotations", model->arrayLiteral(1, Qt::DisplayRole));
}

@ The other settings are updated based on values passed through the parameter
to the update method.

@<ValueAnnotationConfWidget implementation@>=
void ValueAnnotationConfWidget::updateSourceColumn(const QString &source)
{
	updateAttribute("source", source);
}

void ValueAnnotationConfWidget::updateStart(bool noteOnStart)
{
	updateAttribute("emitOnStart", noteOnStart);
}

@ The widget is registered with the configuration system.

@<Register device configuration widgets@>=
app.registerDeviceConfigurationWidget("valueannotation",
	ValueAnnotationConfWidget::staticMetaObjet);

@ While it is possible to implement this feature with |ThresholdDetector|
objects, the code to handle these would be difficult to understand and there
would be excessive overhead in moving measurements through all of these.
Instead, we create a new class that watches for any sort of measurement
change and produces the annotation signals directly.

As measured values are represented as a |double|, a small value should be
provided such that comparisons are not against the value directly but instead
are against the value plus or minus this other small value.

Method names have been chosen to be compatible with the |AnnotationButton|
class.

@<Class declarations@>=
class ValueAnnotation : public QObject
{
	Q_OBJECT
	public:
		ValueAnnotation();
		Q_INVOKABLE void setAnnotation(double value, const QString &annotation);
	public slots:
		void newMeasurement(Measurement measure);
		void annotate();
		void setAnnotationColumn(int column);
		void setTemperatureColumn(int column);
		void setTolerance(double epsilon);
	signals:
		void annotation(QString annotation, int tempcolumn, int notecolumn);
	private:
		int lastIndex;
		int annotationColumn;
		int measurementColumn;
		QList<double> values;
		QStringList annotations;
		double tolerance;
}

@ Most of the work of this class happens in the |newMeasurement| method. This
compares the latest measurement with every value that has an associated
annotation. If the value is near enough to a value in the list, the index of
that value is compared with the index of the previous annotation (if any) and
if the indices are different, the appropriate annotation is emitted.

@<ValueAnnotation implementation@>=
void ValueAnnotation::newMeasurement(Measurement measure)
{
	for(int i = 0; i < values.size(); i++)
	{
		if(measure.temperature() > values.at(i) - tolerance &&
		   measure.temperature() < values.at(i) + tolerance)
		{
			if(i != lastIndex)
			{
				lastIndex = i;
				emit annotation(annotations.at(i), measurementColumn, annotationColumn);
			}
		}
	}
}

@ Another method is used to emit an annotation matching the current state at
the start of a batch if that is desired. This will not produce any output if
no state has yet been matched.

@<ValueAnnotation implementation@>=
void ValueAnnotation::annotate()
{
	if(lastIndex > -1)
	{
		emit annotation(annotations.at(lastIndex), measurementColumn, annotationColumn);
	}
}

@ Values and annotations are added to separate lists with new mappings always
appended. Entries are never removed from these lists.

@<ValueAnnotation implementation@>=
void ValueAnnotation::setAnnotation(double value, const QString &annotation)
{
	values.append(value);
	annotations.append(annotation);
}

@ The remaining setter methods are trivial similarly trivial.

@<ValueAnnotation implementation@>=
void ValueAnnotation::setAnnotationColumn(int column)
{
	annotationColumn = column;
}

void ValueAnnotation::setTemperatureColumn(int column)
{
	measurementColumn = column;
}

void ValueAnnotation::setTolerance(double epsilon)
{
	tolerance = epsilon;
}

@ This just leaves a trivial constructor.

@<ValueAnnotation implementation@>=
ValueAnnotation::ValueAnnotation() : QObject(),
	lastIndex(-1), annotationColumn(2), measurementColumn(1), tolerance(0.05)
{
	/* Nothing needs to be done here. */
}

