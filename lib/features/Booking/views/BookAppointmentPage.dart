import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/models/Salon.dart';
import 'package:saloony/core/models/Treatment.dart';
import 'package:saloony/core/services/TreatmentService.dart';
import 'package:saloony/core/services/AppointmentService.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';

class BookAppointmentPage extends StatefulWidget {
  final Salon salon;

  const BookAppointmentPage({super.key, required this.salon});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final TreatmentService _treatmentService = TreatmentService();
  final AppointmentService _appointmentService = AppointmentService();

  DateTime _selectedDate = DateTime.now();
  String? _selectedSlot;
  Treatment? _selectedTreatment;
  String? _selectedSpecialist;

  List<Treatment> _availableTreatments = [];
  bool _loading = true;
  bool _booking = false;

  final List<String> _slots = [
    '9 to 12 AM',
    '12 to 3 PM',
    '3 to 6 PM',
    '6 to 9 PM',
  ];

  final List<Map<String, String>> _specialists = [
    {'name': 'Lily', 'role': 'Manager'},
    {'name': 'Lee', 'role': 'Manager'},
    {'name': 'John', 'role': 'Assistant'},
  ];

  @override
  void initState() {
    super.initState();
    _loadTreatmentsForSalon();
  }

  Future<void> _loadTreatmentsForSalon() async {
    try {
      final res = await _treatmentService.getAllTreatments();
      if (res['success']) {
        final List<Treatment> all = (res['treatments'] as List)
            .map((e) => Treatment.fromJson(e as Map<String, dynamic>))
            .toList();

        // Filter by salon's offered treatments if available
        final ids = widget.salon.salonTreatmentsIds ?? [];
        final avail = all.where((t) => ids.contains(t.treatmentId)).toList();
        setState(() {
          _availableTreatments = avail.isNotEmpty ? avail : all;
          if (_availableTreatments.isNotEmpty) _selectedTreatment = _availableTreatments.first;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading treatments: $e');
      setState(() => _loading = false);
    }
  }

  void _pickDate(DateTime date) {
    setState(() => _selectedDate = date);
  }

  Future<void> _confirmBooking() async {
    if (_selectedTreatment == null || _selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a service and a time slot')));
      return;
    }

    setState(() => _booking = true);
    try {
      final res = await _appointmentService.bookAppointment(
        salonId: widget.salon.salonId!,
        treatmentId: _selectedTreatment!.treatmentId,
        appointmentDate: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
        appointmentTime: _selectedSlot!,
      );

      if (res['success']) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment booked successfully')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Booking failed')));
      }
    } catch (e) {
      debugPrint('Error booking appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking failed')));
    } finally {
      setState(() => _booking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SaloonyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: SaloonyColors.primary),
        title: Text('Book Appointment', style: GoogleFonts.poppins(color: SaloonyColors.primary)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Salon info
                  Row(
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(widget.salon.salonPhotosPaths?.isNotEmpty == true ? '${widget.salon.salonPhotosPaths!.first}' : 'https://via.placeholder.com/80')),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.salon.salonName, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: SaloonyColors.textPrimary)),
                            const SizedBox(height: 4),
                            Text(widget.salon.salonDescription ?? '', style: GoogleFonts.poppins(fontSize: 12, color: SaloonyColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Service selector
                  Text('Select Service', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: SaloonyColors.textPrimary)),
                  const SizedBox(height: 8),
                  DropdownButton<Treatment>(
                    isExpanded: true,
                    value: _selectedTreatment,
                    items: _availableTreatments.map((t) => DropdownMenuItem(value: t, child: Text(t.treatmentName))).toList(),
                    onChanged: (v) => setState(() => _selectedTreatment = v),
                  ),
                  const SizedBox(height: 16),

                  // Date selector - horizontal next 7 days
                  Text('Select Date', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: SaloonyColors.textPrimary)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 86,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        final day = DateTime.now().add(Duration(days: index));
                        final selected = day.year == _selectedDate.year && day.month == _selectedDate.month && day.day == _selectedDate.day;
                        return GestureDetector(
                          onTap: () => _pickDate(day),
                          child: Container(
                            width: 84,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: selected ? SaloonyColors.secondary : Colors.white,
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'][day.weekday % 7],
                                  style: GoogleFonts.poppins(color: selected ? Colors.white : SaloonyColors.textPrimary, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                Text('${day.day.toString().padLeft(2,'0')}', style: GoogleFonts.poppins(color: selected ? Colors.white : SaloonyColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Slots
                  Text('Select Slot', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: SaloonyColors.textPrimary)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _slots.map((s) {
                      final sel = _selectedSlot == s;
                      return ChoiceChip(
                        label: Text(s, style: GoogleFonts.poppins(color: sel ? Colors.white : SaloonyColors.textPrimary)),
                        selected: sel,
                        onSelected: (_) => setState(() => _selectedSlot = s),
                        selectedColor: SaloonyColors.primary,
                        backgroundColor: Colors.grey[200],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Specialists
                  Text('Select Specialist', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: SaloonyColors.textPrimary)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final s = _specialists[index];
                        final isSel = _selectedSpecialist == s['name'];
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSpecialist = s['name']),
                          child: Container(
                            width: 100,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSel ? SaloonyColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(radius: 28, backgroundImage: NetworkImage('https://via.placeholder.com/80')),
                                const SizedBox(height: 8),
                                Text(s['name']!, style: GoogleFonts.poppins(color: isSel ? Colors.white : SaloonyColors.textPrimary, fontWeight: FontWeight.w600)),
                                Text(s['role']!, style: GoogleFonts.poppins(color: isSel ? Colors.white70 : SaloonyColors.textSecondary, fontSize: 11)),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: _specialists.length,
                    ),
                  ),

                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Back', style: GoogleFonts.poppins(color: SaloonyColors.textSecondary)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _booking ? null : _confirmBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SaloonyColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _booking ? const SizedBox(height:16,width:16,child:CircularProgressIndicator(color:Colors.white,strokeWidth:2)) : Text('Continue', style: GoogleFonts.poppins(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
