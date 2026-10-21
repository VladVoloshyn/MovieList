import Foundation
import SwiftUI

enum AppRoute: Hashable {
    case movieDetails(UUID)
}

enum AppSheet: Identifiable {
    case addMovie
    case editMovie(UUID)

    var id: String {
        switch self {
        case .addMovie:
            return "addMovie"
        case .editMovie(let id):
            return "editMovie-\(id)"
        }
    }
}

@Observable
class AppRouter {
    var path = NavigationPath()
    var presentedSheet: AppSheet?

    func showMovieDetails(id: UUID) {
        path.append(AppRoute.movieDetails(id))
    }

    func showAddMovie() {
        presentedSheet = .addMovie
    }

    func showEditMovie(id: UUID) {
        presentedSheet = .editMovie(id)
    }

    func dismissSheet() {
        presentedSheet = nil
    }

    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func goToRoot() {
        path = NavigationPath()
    }
}
