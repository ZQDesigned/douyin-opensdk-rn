import { useEffect } from 'react';
import { StyleSheet, View, Text } from 'react-native';
import { initSDK } from 'douyin-opensdk-rn';

export default function App() {

  useEffect(() => {
    initSDK('clientKey');
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
