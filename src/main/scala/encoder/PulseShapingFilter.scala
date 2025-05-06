package encoder

import chisel3._
import chisel3.util._
import chisel3.Bundle

class PulseShapingFilter extends Module {
    val io = IO(new Bundle {
        val A = Input(SInt(3.W))
        val B = Input(SInt(3.W))
        val C = Input(SInt(3.W))
        val D = Input(SInt(3.W))
        val Ashaped = Output(SInt(7.W))
        val Bshaped = Output(SInt(7.W))
        val Cshaped = Output(SInt(7.W))
        val Dshaped = Output(SInt(7.W))
    })

    val Areg = RegInit(0.S(3.W))
    val Breg = RegInit(0.S(3.W))
    val Creg = RegInit(0.S(3.W))
    val Dreg = RegInit(0.S(3.W))

    Areg := io.A
    Breg := io.B
    Creg := io.C
    Dreg := io.D

    io.Ashaped := (io.A * 3.S) + Areg 
    io.Bshaped := (io.B * 3.S) + Breg 
    io.Cshaped := (io.C * 3.S) + Creg 
    io.Dshaped := (io.D * 3.S) + Dreg 
}