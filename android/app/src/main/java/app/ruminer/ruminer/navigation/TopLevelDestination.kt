package app.ruminer.ruminer.navigation

import app.ruminer.ruminer.R
import app.ruminer.ruminer.core.designsystem.icon.RuminerIcons

enum class TopLevelDestination(
    val selectedIcon: Int,
    val unselectedIcon: Int,
    val iconTextId: Int,
    val titleTextId: Int,
    val route: String,
) {
    FOLLOWING(
        selectedIcon = RuminerIcons.Following,
        unselectedIcon = RuminerIcons.FollowingEmpty,
        iconTextId = R.string.following,
        titleTextId = R.string.following,
        route = Routes.Following.route
    ),
    INBOX(
        selectedIcon = RuminerIcons.Inbox,
        unselectedIcon = RuminerIcons.InboxEmpty,
        iconTextId = R.string.inbox,
        titleTextId = R.string.inbox,
        route = Routes.Inbox.route
    ),
    PROFILE(
        selectedIcon = RuminerIcons.Profile,
        unselectedIcon = RuminerIcons.ProfileEmpty,
        iconTextId = R.string.profile,
        titleTextId = R.string.profile,
        route = Routes.Settings.route
    ),
}
