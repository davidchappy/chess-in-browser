import React from 'react';
import renderer from 'react-test-renderer';
import { shallow } from 'enzyme';
import { App } from './App';
import { Game } from './Game/';

describe('rendering App (Snapshot Test)', () => {
  const component = renderer.create(<App />);
  const json = component.toJSON();

  it('renders without crashing', () => {
    expect(json).toMatchSnapshot();
  });

  it('renders Welcome by default', () => {
    expect(json.children[0].props['className']).toBe('Welcome');
  });
});

describe('rendering App (mount test)', () => {
  it('renders Game if server data has been fetched', () => {
    const appWithGameWrapper = shallow(<App fetched={true} />);
    expect(appWithGameWrapper.node.props['children']['type']['displayName']).toBe('Connect(Game)');
  });
});