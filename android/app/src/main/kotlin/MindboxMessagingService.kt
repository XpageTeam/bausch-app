import cloud.mindbox.mobile_sdk.Mindbox
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import mobile.bausch.MainActivity


class MindboxMessagingService : FirebaseMessagingService() {
    override fun onNewToken(token: String) {
        Mindbox.updateFmsToken(applicationContext, token)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        // Метод возвращает boolean, чтобы можно было сделать фолбек для обработки пуш уведомлений
        val messageWasHandled = Mindbox.handleRemoteMessage(
            context = applicationContext,
            activities = mapOf(),
            message = remoteMessage,
            channelId = "push_messages", // Идентификатор канала для уведомлений, отправленных из Mindbox
            channelName = "Получение уведомлений", // Название канала
            pushSmallIcon = android.R.drawable.ic_dialog_info, // Маленька иконка для уведомлений
            defaultActivity = MainActivity::class.java,
            channelDescription = "" // Описание канала
        )

        // if (!messageWasHandled) {
            // Если пуш был не от Mindbox или в нем некорректные данные, то можно написать фолбе для его обработки
        // }
    }
}