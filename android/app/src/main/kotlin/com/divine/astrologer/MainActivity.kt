package app.divine.astrologer
import android.annotation.SuppressLint
import android.os.Bundle
import android.telephony.SubscriptionInfo
import android.telephony.SubscriptionManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "app.divine.astrologer/sim_info"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSimNumbers") {
                val simNumbers = getSimNumbers()
                if (simNumbers != null) {
                    result.success(simNumbers)
                } else {
                    result.error("UNAVAILABLE", "SIM card numbers not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    @SuppressLint("MissingPermission")
    private fun getSimNumbers(): List<String>? {
        val subscriptionManager = getSystemService(TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
        val subscriptionInfoList = subscriptionManager.activeSubscriptionInfoList

        return subscriptionInfoList?.map { it.number }
    }
//    override fun getBackgroundMode(): FlutterActivityLaunchConfigs.BackgroundMode {
//        return FlutterActivityLaunchConfigs.BackgroundMode.transparent
//    }
}