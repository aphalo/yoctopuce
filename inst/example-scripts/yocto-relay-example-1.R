library(yoctopuce)

y_initialise("yocto_relay")

Relay1 <- yocto_relay$YRelay$FindRelay("RELAYLO1-B263A.relay1")
if (is.null(Relay1)) {
  stop('No module connected (check cable)')
}
Relay1$describe()
Relay1$get_functionId()

Relay2 <- yocto_relay$YRelay$FindRelay("RELAYLO1-B263A.relay2")
if (is.null(Relay2)) {
  stop('No module connected (check cable)')
}
Relay2$describe()
Relay2$get_functionId()

Relay1$get_advertisedValue()
Relay1$set_maxTimeOnStateA(100)
Relay1$set_maxTimeOnStateB(0)
Relay1$set_state(Relay1$STATE_A)
Relay1$set_state(Relay1$STATE_B)

Relay2$delayedPulse(1000, 2000) # wait 1s, switch ON for 2s

