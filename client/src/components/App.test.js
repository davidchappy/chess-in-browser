import React from 'react';
import renderer from 'react-test-renderer';
import { App } from './App';

describe('rendering App (Snapshot Test)', () => {
  const component = renderer.create(<App />);
  const json = component.toJSON();

  it('renders without crashing', () => {
    expect(json).toMatchSnapshot();
  });

  it('renders Welcome by default', () => {
    expect(json.children[0].props['className']).toBe('Welcome');
  });

  it('renders Game if server data has been fetched', () => {
    const componentWithData = renderer.create(<App fetched={true}/>);
    const gameJson = componentWithData.toJSON();
  });
});