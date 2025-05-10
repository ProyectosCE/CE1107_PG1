package com.example.facapp

import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.NumberPicker
import android.widget.RadioGroup
import android.widget.Switch
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import java.net.HttpURLConnection
import java.net.URL

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }



//        valor maximo que puede tener el acumulado


        val numberPicker = findViewById<NumberPicker>(R.id.numberPicker)
        numberPicker.minValue = 0
        numberPicker.maxValue = 15
        numberPicker.wrapSelectorWheel = true
        numberPicker.value = 5
        numberPicker.isEnabled = true



//        que solo un switch este prendido



        val switch1 = findViewById<Switch>(R.id.switch1)
        val switch2 = findViewById<Switch>(R.id.switch2)
        val switch3 = findViewById<Switch>(R.id.switch3)
        val switch4 = findViewById<Switch>(R.id.switch4)

        val switches = listOf(switch1, switch2, switch3, switch4)

        for (s in switches) {
            s.setOnCheckedChangeListener { _, isChecked ->
                if (isChecked) {
                    switches.filter { it != s }.forEach { it.isChecked = false }
                }
            }
        }


        //encender led
        val btnEncnder = findViewById<Button>(R.id.CLK)

        btnEncnder.setOnClickListener {
            val url = "http://192.168.4.1/led/on" // CAMBIADO

            Thread {
                try {
                    val connection = URL(url).openConnection() as HttpURLConnection
                    connection.requestMethod = "GET"
                    connection.connectTimeout = 5000  // Agregar un timeout
                    connection.readTimeout = 5000

                    val responseCode = connection.responseCode
                    if (responseCode == HttpURLConnection.HTTP_OK) {
                        Log.d("ESP8266", "Conexión exitosa, respuesta: $responseCode")
                    } else {
                        Log.e("ESP8266", "Error en la respuesta: $responseCode")
                    }
                    connection.disconnect()
                } catch (e: Exception) {
                    e.printStackTrace()
                    Log.e("ESP8266", "Error en la conexión: ${e.message}")
                }
            }.start()
        }

    }
}