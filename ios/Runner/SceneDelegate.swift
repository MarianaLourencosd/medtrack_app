import Flutter
import UIKit
import app_links

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // O Flutter configura a cena e encaminha o ciclo de vida aos plugins.
    // Sem esta chamada a cena não é inicializada corretamente.
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    // Em uma abertura "fria", o link chega nas opções de conexão da cena.
    for context in connectionOptions.urlContexts {
      AppLinks.shared.handleLink(url: context.url)
    }

    for userActivity in connectionOptions.userActivities {
      if let url = userActivity.webpageURL {
        AppLinks.shared.handleLink(url: url)
      }
    }
  }

  override func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {
    super.scene(scene, openURLContexts: URLContexts)

    for context in URLContexts {
      AppLinks.shared.handleLink(url: context.url)
    }
  }

  override func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    super.scene(scene, continue: userActivity)

    if let url = userActivity.webpageURL {
      AppLinks.shared.handleLink(url: url)
    }
  }
}
