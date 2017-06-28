import React from 'react';
import renderer from 'react-test-renderer';
import { mount } from 'enzyme';
import ConnectedGame, { Game } from './index';

const gameProps = {
  game: {},
  white: {},
  black: {},
  pieces: {},
  board: {},
  selectedPiece: {},
  selectableTiles: {},
  fetching: {},
  fetched: {}
}

describe('rendering Game (Snapshot Test)', () => {
  const component = renderer.create(<Game {...gameProps}/>);
  const json = component.toJSON();

  it('renders without crashing', () => {
    expect(json).toMatchSnapshot();
  });

  it('renders Header and Table', () => {
    expect(json.children[0].props['className']).toBe('chess-header small');
    expect(json.children[1].props['className']).toBe('Table');
  });
});

describe('rendering Game (mount test)', () => {
  const gameWrapper = mount(
    <Game {...gameProps}/>
  );

  it('renders Header', () => {
    const header = gameWrapper.find('.chess-header.small');
    expect(header.length).toBe(1);
  });

  it('renders Table', () => {
    const header = gameWrapper.find('.Table');
    expect(header.length).toBe(1);
  });
});



// describe('rendering App (Snapshot Test)', () => {


//   it('renders Welcome by default', () => {
//     expect(json.children[0].props['className']).toBe('Welcome');
//   });
// });

// describe('rendering App (mount test)', () => {
//   it('renders Game if server data has been fetched', () => {
//     const appWithGameWrapper = shallow(<App fetched={true} />);
//     expect(appWithGameWrapper.node.props['children']['type']['displayName']).toBe('Connect(Game)');
//   });
// });

// describe('starting Guest Game', () => {
//   const createGuestGame = jest.fn();
//   const welcomeWrapper = mount(
//     <Game createGuestGame={createGuestGame}/>
//   )

//   it('calls createGuestGame', () => {
//     const button = welcomeWrapper.find('.Game-intro button');
//     button.simulate('click');
//     expect(createGuestGame).toBeCalled();
//   });
// });