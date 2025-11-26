import TTLock from "react-native-ttlock";
import lockConfig from "../lockConfig";

class BLEService {

  startScan(onFound) {
    // Start BLE scan with TTLock SDK
    try {
      // Check if lock config is properly set up
      if (!lockConfig.LOCK_MAC || lockConfig.LOCK_MAC === "AA:BB:CC:DD:EE:FF") {
        console.warn("Lock MAC address not configured. Please update config/lockConfig.js");
        if (onFound) onFound(null);
        return;
      }

      TTLock.startBleScan((device) => {
        console.log("Found device: ", device);
        // device.mac might differ by platform; check available fields
        const mac = device.mac || device.address || device.serialNumber;
        if (mac && mac.toUpperCase() === lockConfig.LOCK_MAC.toUpperCase()) {
          onFound(device);
        }
      });
    } catch (e) {
      console.error("startScan error", e);
      if (onFound) onFound(null);
    }
  }

  connectToLock(callback) {
    try {
      // Check if lock config is properly set up
      if (!lockConfig.LOCK_MAC || lockConfig.LOCK_MAC === "AA:BB:CC:DD:EE:FF") {
        console.warn("Lock MAC address not configured");
        callback(false);
        return;
      }

      TTLock.stopBleScan();
      TTLock.connect(lockConfig.LOCK_MAC, (success, error) => {
        if (success) {
          console.log("Connected to lock");
          callback(true);
        } else {
          console.log("Failed to connect", error);
          callback(false);
        }
      });
    } catch (e) {
      console.error("connectToLock error", e);
      callback(false);
    }
  }

  unlock(callback) {
    try {
      // Check if lock config is properly set up
      if (!lockConfig.LOCK_DATA || lockConfig.LOCK_DATA === "PUT_LOCK_DATA_HERE" ||
          !lockConfig.AES_KEY || lockConfig.AES_KEY === "PUT_AES_KEY_HERE") {
        console.warn("Lock credentials not configured. Please update config/lockConfig.js");
        callback(false);
        return;
      }

      TTLock.controlLock(
        {
          lockData: lockConfig.LOCK_DATA,
          aesKey: lockConfig.AES_KEY,
          controlAction: TTLock.ControlAction ? TTLock.ControlAction.UNLOCK : "UNLOCK",
        },
        (success, errorCode) => {
          console.log("Unlock result:", success, errorCode);
          callback(!!success);
        }
      );
    } catch (e) {
      console.error("unlock error", e);
      callback(false);
    }
  }

  lock(callback) {
    try {
      // Check if lock config is properly set up
      if (!lockConfig.LOCK_DATA || lockConfig.LOCK_DATA === "PUT_LOCK_DATA_HERE" ||
          !lockConfig.AES_KEY || lockConfig.AES_KEY === "PUT_AES_KEY_HERE") {
        console.warn("Lock credentials not configured. Please update config/lockConfig.js");
        callback(false);
        return;
      }

      TTLock.controlLock(
        {
          lockData: lockConfig.LOCK_DATA,
          aesKey: lockConfig.AES_KEY,
          controlAction: TTLock.ControlAction ? TTLock.ControlAction.LOCK : "LOCK",
        },
        (success, errorCode) => {
          console.log("Lock result:", success, errorCode);
          callback(!!success);
        }
      );
    } catch (e) {
      console.error("lock error", e);
      callback(false);
    }
  }

  disconnect() {
    try {
      TTLock.disconnect(lockConfig.LOCK_MAC);
    } catch (e) {
      console.error("disconnect error", e);
    }
  }
}

export default new BLEService();
