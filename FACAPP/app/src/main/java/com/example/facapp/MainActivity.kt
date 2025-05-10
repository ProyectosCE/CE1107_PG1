package com.example.facapp

import android.annotation.SuppressLint
import android.graphics.Paint
import android.os.Bundle
import android.text.SpannableString
import android.text.style.UnderlineSpan
import android.util.Log
import android.widget.Button
import android.widget.NumberPicker
import android.widget.NumberPicker.OnValueChangeListener
import android.widget.RadioGroup
import android.widget.TextView
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import java.net.HttpURLConnection
import java.net.URL

class MainActivity : AppCompatActivity() {
    @SuppressLint("MissingInflatedId")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }


        val textView = findViewById<TextView>(R.id.acum)
        val content = "Accumulated"
        val contentUnderline = SpannableString(content)
        contentUnderline.setSpan(UnderlineSpan(), 0, content.length, 0)
        textView.text = contentUnderline




    //codigo encode para la ALU:

        val Operaciones = findViewById<RadioGroup>(R.id.operaciones)
        var SelectedId = 0
        var EncodeOperacion = "00"

        Operaciones.setOnCheckedChangeListener { group, checkedId ->
            SelectedId = checkedId
            if(SelectedId == 2131231032){
                EncodeOperacion = "00"
            }
            else if(SelectedId == 2131231159){
                EncodeOperacion = "01"

            }

            else if(SelectedId == 2131231243){
                EncodeOperacion = "10"
            }
            else{
                EncodeOperacion = "11"
            }
            Log.d("Operacion", EncodeOperacion)

        }












//        valor maximo que puede tener el acumulado
        val numberPicker = findViewById<NumberPicker>(R.id.numberPicker)
        numberPicker.minValue = 0
        numberPicker.maxValue = 15
        numberPicker.wrapSelectorWheel = true
        numberPicker.value = 5
        numberPicker.isEnabled = true
        var acumulado =  0
        var binary_acumulado = "0000";




        numberPicker.setOnValueChangedListener(OnValueChangeListener { picker, oldVal, newVal ->
             acumulado = newVal
             binary_acumulado = Integer.toBinaryString(acumulado).padStart(4,'0')
            Log.d("picker value", binary_acumulado.toString() + "")
        })









        //encender led
        val btnEncnder = findViewById<Button>(R.id.CLK)

        btnEncnder.setOnClickListener {
            btnEncnder.isEnabled = false // 🔒 Desactiva el botón para evitar múltiples toques

            var ByteCLK = binary_acumulado + EncodeOperacion + "10"
            val url = "http://192.168.4.1/data/$ByteCLK"

            Thread {
                try {
                    val connection = URL(url).openConnection() as HttpURLConnection
                    connection.requestMethod = "GET"
                    connection.connectTimeout = 5000
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

                // ✅ Volver a activar el botón en la UI
                runOnUiThread {
                    btnEncnder.isEnabled = true
                }

            }.start()
        }



        //logica para mandarel el rst


        val btnReset = findViewById<Button>(R.id.RST)

        btnReset.setOnClickListener {
            btnEncnder.isEnabled = false // 🔒 Desactiva el botón para evitar múltiples toques

            var ByteReset = "0000" + "00" + "01"
            val url = "http://192.168.4.1/data/$ByteReset"

            Thread {
                try {
                    val connection = URL(url).openConnection() as HttpURLConnection
                    connection.requestMethod = "GET"
                    connection.connectTimeout = 5000
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

                // ✅ Volver a activar el botón en la UI
                runOnUiThread {
                    btnEncnder.isEnabled = true
                }

            }.start()
        }









    }







}