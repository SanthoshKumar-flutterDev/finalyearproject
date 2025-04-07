import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:portfoliobuilder/templatesviewing/templateviewcard.dart';

import '../provider/template_provider.dart';

class TemplateViewPage extends StatelessWidget {
  const TemplateViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final templateProvider = Provider.of<TemplateProvider>(context);

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Choose a Template",
                  style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: Colors.indigo.shade900),
                ),
              ),
              SizedBox(height: 50.h),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(12.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 1,
                  ),
                  itemCount: templateProvider.templates.length,
                  itemBuilder: (context, index) {
                    final template = templateProvider.templates[index];
                    return PortfolioViewCard(template: template);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
