import React, { useState } from "react";
import { View, Text, Button, StyleSheet, Alert } from "react-native";
import BLEService from "./services/BLEService";

export default function App() {
  const [status, setStatus] = useState("Not connected");

  const handleConnect = () => {
    setStatus("Scanning...");
    BLEService.startScan((device) => {
      setStatus("Device found. Connecting...");
      BLEService.connectToLock((connected) => {
        if (connected) setStatus("Connected!");
        else setStatus("Failed to connect");
      });
    });
  };

  const handleUnlock = () => {
    setStatus("Unlocking...");
    BLEService.unlock((ok) => {
      setStatus(ok ? "Door unlocked!" : "Unlock failed");
      Alert.alert(ok ? "Success" : "Failure", ok ? "Door unlocked." : "Unlock failed.");
    });
  };

  const handleLock = () => {
    setStatus("Locking...");
    BLEService.lock((ok) => {
      setStatus(ok ? "Door locked!" : "Lock failed");
      Alert.alert(ok ? "Success" : "Failure", ok ? "Door locked." : "Lock failed.");
    });
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>TTLock BLE MVP</Text>
      <Text style={styles.status}>{status}</Text>

      <Button title="Connect" onPress={handleConnect} />
      <View style={{ height: 20 }} />

      <Button title="Unlock" onPress={handleUnlock} />
      <View style={{ height: 20 }} />

      <Button title="Lock" onPress={handleLock} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 40,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#ffffff",
  },
  title: {
    fontSize: 22,
    fontWeight: "700",
    marginBottom: 20,
  },
  status: {
    marginBottom: 30,
    fontSize: 16,
  },
});
