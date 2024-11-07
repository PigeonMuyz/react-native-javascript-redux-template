import {Component} from 'react';
import {Provider} from 'react-redux';
import {create} from 'dva-core';
import {models} from './models';
import {Text} from 'react-native';


const app = create();

models.forEach(item => {
  app.model(item);
});

app.start();

const store = app._store;

class App extends Component {
  constructor(props) {
    super(props);
  }
  render() {
    return (
      <Provider store={store}>
        <Text>React Template</Text>
      </Provider>
    );
  }
}
export default App;
