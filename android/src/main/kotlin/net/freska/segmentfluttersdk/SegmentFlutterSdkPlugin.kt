package net.freska.segmentfluttersdk

import com.segment.analytics.Analytics
import com.segment.analytics.Properties
import com.segment.analytics.Traits
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*

class SegmentFlutterSdkPlugin private constructor(val registrar: Registrar) : MethodCallHandler {

  companion object {

    private var analytics: Analytics? = null

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "net.freska.fluttersegmentsdk/segment_flutter_sdk")
      channel.setMethodCallHandler(SegmentFlutterSdkPlugin(registrar))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) = when (call.method) {
    "init" -> handleInitAnalytics(call, result)
    "identify" -> track(call, result) { arguments ->
      val userId = arguments["userId"] as? String
      if (userId.isNullOrEmpty()) {
        reset()
      } else {
        identify(userId!!)
      }
    }
    "trackScreen" -> track(call, result) { arguments -> screen(arguments["name"] as String, extractProperties(arguments)) }
    "trackEvent" -> track(call, result) { arguments -> track(arguments["name"] as String, extractProperties(arguments)) }
    else -> result.notImplemented()
  }

  @Suppress("UNCHECKED_CAST")
  private fun handleInitAnalytics(call: MethodCall, result: Result) {
    val arguments = call.arguments as Map<String, *>
    val writeKey = arguments["writeKey"] as String
    checkNotNull(writeKey) { "writeKey parameter is missing" }
    // If already initialised, use previous object. If not, initialise it now.
    // This prevents crashing if flutter app is closed and opened again, as registrar activity will be recalled
    analytics = analytics ?: Analytics.Builder(registrar.context(), writeKey).apply {
      // Add arguments if included to the builder
      (arguments["flushQueueSize"] as? Int)?.run { flushQueueSize(this) }
      // TODO add flushInterval
      (arguments["collectDeviceId"] as? Boolean)?.run { collectDeviceId(this) }
      // TODO add defaultOptions
      (arguments["tag"] as? String)?.run { tag(this) }
      (arguments["logLevel"] as? String)?.run {
        try {
          logLevel(Analytics.LogLevel.valueOf(this))
        } catch (_: IllegalArgumentException) {
          result.error("IllegalArgumentException", "Given $this LogLevel does not match: NONE, INFO, DEBUG or VERBOSE", null)
        }
      }
      // TODO add networkExecutor
      // TODO add connectionFactory
      // TODO add crypto
      (arguments["trackApplicationLifecycleEvents"] as? Boolean)?.run { if (this) trackApplicationLifecycleEvents() }
      (arguments["recordScreenViews"] as? Boolean)?.run { if (this) recordScreenViews() }
      (arguments["trackAttributionInformation"] as? Boolean)?.run { if (this) trackAttributionInformation() }
    }.build().also {
      Analytics.setSingletonInstance(analytics)
    }
    result.success(null)
  }

  @Suppress("UNCHECKED_CAST")
  private fun extractProperties(arguments: Map<String, *>): Properties {
    // Add the properties
    return Properties().apply {
      (arguments["properties"] as? Map<String, *>)?.forEach { (key, value) ->
        if (value != null) {
          putValue(key, value)
        }
      }
    }
  }

  @Suppress("UNCHECKED_CAST")
  private fun track(call: MethodCall, result: Result, trackAction: Analytics.(Map<String, *>) -> Unit) {
    analytics.whenNotNull({
      trackAction(call.arguments as Map<String, *>)
      result.success(null)
    }) {
      result.error("Analytics null", "Analytics is null, check if it is properly initialised", null)
    }

  }

}
