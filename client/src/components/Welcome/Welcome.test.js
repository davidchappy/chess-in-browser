import React from 'react';
import renderer from 'react-test-renderer';
import { mount } from 'enzyme';
import Welcome from './index';

describe('rendering Welcome (Snapshot Test)', () => {
  const component = renderer.create(<Welcome />);
  const json = component.toJSON();

  it('renders without crashing', () => {
    expect(json).toMatchSnapshot();
  });
});

describe('rendering Welcome (mount test)', () => {
  const welcomeWrapper = mount(
    <Welcome />
  );

  it('renders a button to start a guest game', () => {
    const button = welcomeWrapper.find('.Welcome-intro button');
    expect(button.text()).toBe('Start Game As Guest');
  });
});

describe('starting Guest Game', () => {
  const createGuestGame = jest.fn();
  const welcomeWrapper = mount(
    <Welcome createGuestGame={createGuestGame}/>
  )

  it('calls createGuestGame', () => {
    const button = welcomeWrapper.find('.Welcome-intro button');
    button.simulate('click');
    expect(createGuestGame).toBeCalled();
  });
});