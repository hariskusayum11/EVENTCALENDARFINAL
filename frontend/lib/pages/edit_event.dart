import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/controllers/event_service.dart';
import 'package:frontend/models/event_model.dart';

class EditEvent extends StatefulWidget {
  final EventModel event;

  EditEvent({required this.event});

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();
  final EventService _eventService = EventService();

  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.eventName);
    _dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(widget.event.eventDate));
    _startTimeController = TextEditingController(text: widget.event.startTime);
    _endTimeController = TextEditingController(text: widget.event.endTime);
    _descController = TextEditingController(text: widget.event.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: widget.event.eventDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  void _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(controller.text.split(':')[0]),
        minute: int.parse(controller.text.split(':')[1]),
      ),
    );

    if (selectedTime != null) {
      setState(() {
        controller.text = selectedTime.format(context);
      });
    }
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _eventService.updateEvent(
          widget.event.id,
          _titleController.text,
          _descController.text,
          DateTime.parse(_dateController.text),
          _startTimeController.text,
          _endTimeController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event updated successfully')));
        Navigator.pop(context, true); // Return to previous page with success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update event')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color(0xFFC3D9E8), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color(0xFFC3D9E8), width: 2.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter event name' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color(0xFFC3D9E8), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color(0xFFC3D9E8), width: 2.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please select a date' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _startTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _selectTime(context, _startTimeController),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color(0xFFC3D9E8), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color(0xFFC3D9E8), width: 2.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please select a start time' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _endTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'End Time',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _selectTime(context, _endTimeController),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color(0xFFC3D9E8), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color(0xFFC3D9E8), width: 2.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please select an end time' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color(0xFFC3D9E8), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color(0xFFC3D9E8), width: 2.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveEvent,
                child: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC3D9E8), // Pastel Blue
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
