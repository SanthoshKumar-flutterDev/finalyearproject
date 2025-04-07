import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfoliobuilder/formpage/personal_section.dart';
import 'package:portfoliobuilder/formpage/stepper_form.dart';
import 'package:portfoliobuilder/pages/aboutpage.dart';
import 'package:portfoliobuilder/pages/features.dart';
import 'package:portfoliobuilder/pages/helppage.dart';
import 'package:portfoliobuilder/portfolio/darkthemeportfolio.dart';
import 'package:portfoliobuilder/templatesviewing/templateviewpage.dart';
import '../auth_service/SignupPage.dart';
import '../formpage/project_section.dart';
import '../formpage/skillsection_form.dart';
import '../pages/Homepage.dart';
import '../portfoliotemplates/template_one.dart';
import '../profilepage/profileview.dart';
import '../templating/generate_portfolio_page.dart';
import '../templating/template_selection_page.dart';
import 'package:portfoliobuilder/templating/portfolio_templates.dart';
import 'Navigationbar.dart';





final GoRouter route = GoRouter(
  initialLocation: '/navigationpage',

  routes: [


    GoRoute(
        path: '/signuppage',
      builder: (context, state) => SignUpPage()
    ),

    GoRoute(
        path: '/navigationpage',
      builder: (context, state) => MyNavigationBar()
    ),

    GoRoute(
        path: '/home',
        builder: (context, state) => Homepage()
    ),

    GoRoute(
        path: '/features',
      builder: (context, state) => features()
    ),

    GoRoute(
        path: '/helppage',
      builder: (context, state) => Helppage()
    ),

    GoRoute(
        path: '/aboutpage',
      builder: (context, state) => Aboutpage()
    ),

    GoRoute(
        path: '/form',
      builder: (context, state) => PersonalSection()
    ),

    GoRoute(
      path: '/skills',
      builder: (context, state) => SkillSection()
      ),

    GoRoute(
      path: '/projects',
      builder: (context, state) => ProjectsSection()
      ),

    GoRoute(
      path: '/stepperform',
      builder: (context, state) => StepperForm()
      ),

    GoRoute(
      path: '/templateviewpage',
      builder: (context, state) => TemplateViewPage()
      ),


    GoRoute(
      path: '/profileview',
      builder: (context, state) => Profileview()
      ),

    GoRoute(
      path: '/templatespage',
      builder: (context, state) => TemplateSelectionPage()
      ),

    GoRoute(
      path: '/template_one',
      builder: (context, state) => ProfilePageAlignment()
      ),




    GoRoute(
      path: "/portfolio/:id",
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        if (extra == null || !extra.containsKey('userId') || !extra.containsKey('templateId')) {
          return Scaffold(
            body: Center(child: Text("Error: Missing user data or template.")),
          );
        }

        return GeneratedPortfolioPage(
          userId: extra['userId'] as String,
          templateId: extra['templateId'] as String,
        );
      },
    ),





  ],

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final String currentPath = state.uri.toString(); // Correct method

    if (user == null && currentPath != '/login') {
      return '/signuppage';
    }
    return null;
  },
);


