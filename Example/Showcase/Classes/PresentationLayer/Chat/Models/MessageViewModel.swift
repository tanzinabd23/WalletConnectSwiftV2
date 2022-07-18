import Foundation
import Chat

struct MessageViewModel {
    private let message: Message
    private let thread: Chat.Thread

    init(message: Message, thread: Chat.Thread) {
        self.message = message
        self.thread = thread
    }

    var currentAccount: Account {
        return thread.selfAccount
    }

    var isCurrentUser: Bool {
        return currentAccount == message.authorAccount
    }

    var text: String {
        return message.message
    }

    var showAvatar: Bool {
        return !isCurrentUser
    }
}
