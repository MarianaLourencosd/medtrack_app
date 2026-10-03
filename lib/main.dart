import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'constantes/tema_app.dart';
import 'recursos/menu_acessibilidade.dart';
import 'telas/home/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MedTrackApp());
}

class MedTrackApp extends StatelessWidget {
  const MedTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: TemaController.modoEscuro,
      builder: (context, isDark, _) {
        return ValueListenableBuilder<double>(
          valueListenable: ConfigAcessibilidade.escalaFonte,
          builder: (context, escala, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: ConfigAcessibilidade.daltonismo,
              builder: (context, daltonismo, _) {
                return ValueListenableBuilder<bool>(
                  valueListenable: ConfigAcessibilidade.altoContraste,
                  builder: (context, altoContraste, _) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: ConfigAcessibilidade.reduzirAnimacoes,
                      builder: (context, reduzirAnimacoes, _) {
                        return MaterialApp(
                          title: 'MedTrack',
                          theme: AppTheme.lightTheme,
                          darkTheme: AppTheme.darkTheme,
                          themeMode:
                              isDark ? ThemeMode.dark : ThemeMode.light,
                          builder: (context, child) {
                            final mq = MediaQuery.of(context);

                            Widget resultado = MediaQuery(
                              data: mq.copyWith(
                                textScaler: TextScaler.linear(
                                  escala.clamp(0.8, 1.6),
                                ),
                                disableAnimations: reduzirAnimacoes,
                              ),
                              child: child ?? const SizedBox.shrink(),
                            );

                            if (daltonismo) {
                              resultado = ColorFiltered(
                                colorFilter: const ColorFilter.matrix(
                                  FiltroDaltonismo.deuteranopia,
                                ),
                                child: resultado,
                              );
                            }

                            if (altoContraste) {
                              resultado = ColorFiltered(
                                colorFilter: const ColorFilter.matrix([
                                  -1, 0, 0, 0, 255,
                                  0, -1, 0, 0, 255,
                                  0, 0, -1, 0, 255,
                                  0, 0, 0, 1, 0,
                                ]),
                                child: resultado,
                              );
                            }

                            return resultado;
                          },
                          home: const HomeScreen(),
                          debugShowCheckedModeBanner: false,
                          localizationsDelegates: const [
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate,
                          ],
                          supportedLocales: const [
                            Locale('pt', 'BR'),
                            Locale('en', 'US'),
                          ],
                          locale: const Locale('pt', 'BR'),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}