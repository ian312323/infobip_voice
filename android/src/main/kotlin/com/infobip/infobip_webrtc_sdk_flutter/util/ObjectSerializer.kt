package com.infobip.infobip_webrtc_sdk_flutter.util

import android.os.Build
import androidx.annotation.RequiresApi
import com.google.gson.GsonBuilder
import java.lang.reflect.Modifier
import java.util.*

// serialize "java/kotlin any" to "json any" (string, object, or array)
typealias SerializeFunction = (Any?) -> Any?
typealias SerializeMatcher = (Any) -> Boolean


class ObjectSerializer {
    private val gson = GsonBuilder()
        .setDateFormat("yyyy-MM-dd'T'HH:mm:ssXXX")
        .create()

    @RequiresApi(Build.VERSION_CODES.O)
    private val serializers: List<Pair<SerializeMatcher, SerializeFunction>> = listOf(
        // if needed, add custom serializers here
        this::isEnum to this::enumToString,
        this::isJsonLiteral to this::asIs,
        this::isDate to this::serializeDate,
        this::isMap to this::serializeMap,
        // recursively serialize our DTOs
        this::isInfobipObject to this::serialize
    )

    private fun asIs(obj: Any?): Any? {
        return obj
    }
    @RequiresApi(Build.VERSION_CODES.O)
    private fun serializeMap(obj: Any?): Any? {
        val map = obj as Map<*, *>
        return map.mapValues { serialize(it.value) }
    }
    private fun enumToString(obj: Any?): String {
        return (obj as Enum<*>)?.name?.uppercase().toString()
    }
    private fun serializeDate(obj: Any?): String {
        // basically gson.toJson(), but without the quotation marks (gson adds "...")
        return gson.toJson(obj).let { it.substring(1, it.length - 1) }
    }

    private fun isMap(obj: Any?): Boolean {
        return obj is Map<*, *>
    }
    private fun isEnum(obj: Any): Boolean {
        return obj is Enum<*>
    }
    private fun isJsonLiteral(obj: Any): Boolean {
        return obj is Number || obj is String || obj is Char || obj is Boolean
    }
    private fun isDate(obj: Any): Boolean {
        return obj is Date
    }
    private fun isInfobipObject(obj: Any): Boolean {
        return obj.javaClass.canonicalName!!.startsWith("com.infobip")
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun serializeToString(obj: Any?): String? {
        return serialize(obj)?.let { gson.toJson(it) }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun serialize(obj: Any?): Any? {
        if (obj == null) {
            return null;
        }

        if (isJsonLiteral(obj)) {
            return obj
        }

        if (isDate(obj)) {
            return serializeDate(obj)
        }

        if (isMap(obj)) {
            return serializeMap(obj)
        }

        return obj.javaClass.methods
            .filter {
                it.parameterCount == 0
                        && it.returnType != Void.TYPE
                        && !Modifier.isStatic(it.modifiers)
                        && Modifier.isPublic(it.modifiers)
                        && it.returnType != Class::class.java
                        && it.declaringClass != Object::class.java
            }
            .map { it.name to it.invoke(obj) }
            .filter { it.second != null }
            .map { pair ->
                adjustFieldName(pair.first) to serializers.find { it.first(pair.second!!) }?.second?.invoke(pair.second)
            }
            .toMap()
    }

    private fun adjustFieldName(name: String): String {
        if (name.startsWith("get") && name.length > 3) {
            var res = name.substring(3)
            if (res.length > 1) {
                res = res.replaceFirstChar { it.lowercase() }
            }
            return res
        }
        return name
    }

    fun <T> fromJson(jsonString: String, clazz: Class<T>): T? {
        return gson.fromJson(jsonString, clazz)
    }
}