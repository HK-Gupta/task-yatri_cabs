import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yatri_cabs/config/assets_path.dart';
import 'package:yatri_cabs/config/my_colors.dart';
import 'package:yatri_cabs/presentation/screens/home_screen.dart';

// Define state providers for date and time
final selectedDateFromProvider = StateProvider<DateTime?>((ref) => null);
final selectedDateToProvider = StateProvider<DateTime?>((ref) => null);
final selectedTimeProvider = StateProvider<TimeOfDay?>((ref) => null);

class CabBookingWidget extends ConsumerWidget {
  final BuildContext context;
  final int selectedCategory;
  final int selectedTripType;

  CabBookingWidget({super.key,
    required this.context,
    required this.selectedCategory,
    required this.selectedTripType,
  });

  final TextEditingController pickUpCityController = TextEditingController();
  final TextEditingController dropCityController = TextEditingController();

  Future<void> _selectDate(
      BuildContext context, WidgetRef ref, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      if (isFrom) {
        ref.read(selectedDateFromProvider.notifier).state = picked;
      } else {
        ref.read(selectedDateToProvider.notifier).state = picked;
      }
      print(selectedDateFromProvider);
    }
  }

  Future<void> _selectTime(BuildContext context, WidgetRef ref) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      ref.read(selectedTimeProvider.notifier).state = picked;
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedDateFrom = ref.watch(selectedDateFromProvider);
    var selectedDateTo = ref.watch(selectedDateToProvider);
    var selectedTime = ref.watch(selectedTimeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const SizedBox(height: 4),
            _buildDynamicWidgets(ref, selectedTime, selectedDateFrom, selectedDateTo, true),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16.0),
              ),
              onPressed: () {
                // Add functionality here for 'Explore Cabs'
              },
              child: const Text(
                "Explore Cabs",
                style: TextStyle(fontSize: 20, color: MyColors.textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDynamicWidgets(ref, selectedTime, selectedDateFrom, selectedDateTo, isFrom) {
    switch (selectedCategory) {
      case 0:
        return Column(
          children: [
            _buildTextField(
              label: "Pick-up City",
              hint: "Type City Name",
              icon: ImagePath.location,
              controller: pickUpCityController,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: selectedTripType==0? "Drop City" : "Destination",
              hint: "Type City Name",
              icon: ImagePath.flag,
              controller: dropCityController,
            ),
            const SizedBox(height: 16),
            _buildDateField(
              label: "Pick-up Date",
              hint: selectedDateFrom != null
                  ? DateFormat('dd-MM-yyyy').format(selectedDateFrom!)
                  : "DD-MM-YYYY",
              icon: ImagePath.date,
              onTap: () => _selectDate(context, ref, true),
            ),
            if (selectedTripType==1) ...[
              const SizedBox(height: 16),
              _buildDateField(
                label: "Return Date",
                hint: selectedDateTo != null
                    ? DateFormat('dd-MM-yyyy').format(selectedDateTo!)
                    : "DD-MM-YYYY",
                icon: ImagePath.date,
                onTap: () => _selectDate(context, ref, false),
              ),
            ],
            const SizedBox(height: 16),
            _buildDateField(
              label: "Time",
              hint: selectedTime != null
                  ? selectedTime!.format(context)
                  : "HH:MM",
              icon: ImagePath.time,
              onTap: () => _selectTime(context, ref),
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            _buildTextField(
              label: "Pick-up City",
              hint: "Type City Name",
              icon: ImagePath.location,
              controller: pickUpCityController,
            ),
            const SizedBox(height: 16),
            _buildDateField(
              label: "Pick-up Date",
              hint: selectedDateFrom != null
                  ? DateFormat('dd-MM-yyyy').format(selectedDateFrom!)
                  : "DD-MM-YYYY",
              icon: ImagePath.date,
              onTap: () => _selectDate(context, ref, isFrom),
            ),
            const SizedBox(height: 16),
            _buildDateField(
              label: "Time",
              hint: selectedTime != null
                  ? selectedTime!.format(context)
                  : "HH:MM",
              icon: ImagePath.time,
              onTap: () => _selectTime(context, ref),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            _buildAirportType(ref, MediaQuery.of(context).size.width),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Pick-up City",
              hint: "Type City Name",
              icon: ImagePath.location,
              controller: pickUpCityController,
            ),
            const SizedBox(height: 16),
            _buildDateField(
              label: "Pick-up Date",
              hint: selectedDateFrom != null
                  ? DateFormat('dd-MM-yyyy').format(selectedDateFrom!)
                  : "DD-MM-YYYY",
              icon: ImagePath.date,
              onTap: () => _selectDate(context, ref, isFrom),
            ),
            const SizedBox(height: 16),
            _buildDateField(
              label: "Time",
              hint: selectedTime != null
                  ? selectedTime!.format(context)
                  : "HH:MM",
              icon: ImagePath.time,
              onTap: () => _selectTime(context, ref),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required String icon,
    required TextEditingController controller,
  }) {
    return Container(
      decoration:  BoxDecoration(
        color: MyColors.lightGreen,
        borderRadius: BorderRadius.circular(20)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.asset(
              icon,
            height: 30,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: MyColors.primary
                  ),
                ),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: MyColors.hintColor,
                      fontSize: 10
                    ),
                    filled: false,
                    border: InputBorder.none,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(
                    color: MyColors.hintColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 10
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              controller.clear();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String hint,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration:  BoxDecoration(
          color: MyColors.lightGreen,
          borderRadius: BorderRadius.circular(20)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 30,
            ),
            const SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 14,
                      color: MyColors.primary
                  ),
                ),
                const SizedBox(height: 7,),
                Text(
                  hint,
                  style: TextStyle(
                      color: hint == "DD-MM-YYYY" || hint == "HH:MM" ? Colors.grey : Colors.black,
                    fontSize: 12
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirportType(WidgetRef ref, double width) {
    final selectedIndex = ref.watch(homeScreenProvider);
    final options = ['One-way', 'Round Trip'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final text = entry.value;
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => ref.read(homeScreenProvider.notifier).state = index,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: MyColors.primary
              )
            ),
            height: 28,
            width: width * 0.3,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}


