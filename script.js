// Display a prompt and store the user's input
let userInput = prompt("Paste in YouTube URL:");

// Check if the user entered something or clicked Cancel
if (userInput == null || userInput.trim() == "") {
  window.location.reload();
}


    
function getYouTubeVideoId(url) {
  // Ensure the input is a string
  if (typeof url !== 'string') {
    return null;
  }

  // Regular expression to find the video ID in various YouTube URL formats
  const regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/;
  const match = url.match(regExp);

  // Check if a match was found and if the ID part is 11 characters long
  if (match && match[7].length === 11) {
    return match[7]; // Return the video ID
  } else {
    // Handle cases like shorts or live URLs if the first regex didn't match
    const shortRegExp = /(?:https?:\/\/)?(?:www\.)?youtube\.com\/(?:shorts|live)\/([a-zA-Z0-9_-]{11})/;
    const shortMatch = url.match(shortRegExp);
    if (shortMatch && shortMatch[1]) {
       return shortMatch[1];
    }
    // If no valid ID is found in any known format
    console.error("Could not extract video ID from URL:", url);
    return null;
  }
}

userProvidedVideoId = getYouTubeVideoId(userInput)
if (!userProvidedVideoId) {
  window.location.reload();
}
    
var player;

function onYouTubeIframeAPIReady() {
  player = new YT.Player('player', {
    height: '390',
    width: '640',
    videoId: userProvidedVideoId, // Replace with your desired video ID
    playerVars: {
      'controls': 1, // Show default controls
      'rel': 0 // Prevent related videos at the end
    },
    events: {
      'onReady': onPlayerReady,
      'onStateChange': onPlayerStateChange,
      'onError': onPlayerError
    }
  });
}

function onPlayerReady(event) {

  window.addEventListener('keydown', function(event) {
    if (event.altKey) {
      if (event.code === 'Digit1') {
        event.preventDefault();
        if (player.getPlayerState() === YT.PlayerState.PLAYING) {
          player.pauseVideo();
        } else {
          player.playVideo();
        }
      } else if (event.code === 'Digit2') {
        event.preventDefault();
        var currentTime = player.getCurrentTime();
        var newTime = Math.max(0, currentTime - 10);
        player.seekTo(newTime, true);
      } else if (event.code === 'Digit3') {
        event.preventDefault();
        var currentTime = player.getCurrentTime();
        var newTime = Math.max(0, currentTime - 30);
        player.seekTo(newTime, true);
      } else if (event.code === 'Digit4') {
        event.preventDefault();
        var currentTime = player.getCurrentTime();
        var newTime = Math.min(player.getDuration(), currentTime + 5);
        player.seekTo(newTime, true);
      }
    }
  }, true);
}

function onPlayerStateChange(event) {
  var toggleButton = document.getElementById('toggle-play-pause');
  if (event.data === YT.PlayerState.PLAYING) {
    toggleButton.textContent = 'Pause';
  } else if (event.data === YT.PlayerState.PAUSED) {
    toggleButton.textContent = 'Play';
  }
}

function onPlayerError(event) {
  console.log('Player error:', event.data);
}

    const editor = new EditorJS({
      /**
       * An initial data object to render.
       */
      data: {
          blocks: [
              {
                  type: "header",
                  data: {
                      text: "YouTube NoteTaker Alpha",
                      level: 2
                  }
              },
              {
                  type: "paragraph",
                  data: {
                      text: "macOS Keyboard Shortcuts:"
                  }
              },
              {
                type: "paragraph",
                data: {
                    text: "⌥ + 1 = ⏯️, ⌥ + 2 = ⏪️ 10s, ⌥ + 3 = ⏪️ 30s, ⌥ + 4 = ⏩ 5s,"
                }
              },
              {
                type: "paragraph",
                data: {
                    text: "no Save functionality, page will reset if reloaded."
                }
              }
          ]
      },
  
      /**
       * Id of the div element that Editor.js will be initialized in.
       */
      holder: 'editorjs',
  
      /**
       * Specify the tools you want to use.
       */
      tools: {
          header: {
              class: Header,
              inlineToolbar: true, // Optional: enable inline toolbar for header
              config: {
                  placeholder: 'Enter a header'
              }
          },
          paragraph: {
               class: Paragraph,
               inlineToolbar: true, // Optional: enable inline toolbar for paragraph
               config: {
                   placeholder: 'Start writing...'
               }
          },
          checklist: {
              class: Checklist,
              inlineToolbar: true,
          },
          list: {
              class: EditorjsList,
              inlineToolbar: true,
              config: {
                defaultStyle: 'unordered'
              },
          },
      },
  
      /**
       * Optional: Add a placeholder if the editor is empty.
       */
      placeholder: 'Let\'s write something awesome!',
  
      /**
       * Optional: Callback fired once the editor is ready.
       */
      onReady: () => {
          console.log('Editor.js is ready to work!')
          new Undo({ editor });
      },
  
      /**
       * Optional: Callback fired when something changes in the editor.
       */
      onChange: (api, event) => {
          console.log('Something changed:', event)
      }
  });
  
  // Example of how to save data (you would typically do this on a button click or form submit)
  // setTimeout(() => {
  //     editor.save().then((outputData) => {
  //         console.log('Article data: ', outputData);
  //     }).catch((error) => {
  //         console.log('Saving failed: ', error);
  //     });
  // }, 5000); // Save after 5 seconds for demonstration