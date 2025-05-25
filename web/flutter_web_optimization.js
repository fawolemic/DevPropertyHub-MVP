// Optimization script for Flutter web performance
// Specifically tuned for African market with bandwidth constraints

// Initialize performance tracking
window.flutterWebPerformanceStats = {
  initialLoadTime: null,
  resourceLoadTimes: {},
  bandwidthEstimate: null
};

// Track when resources are loaded
window.addEventListener('load', function() {
  window.flutterWebPerformanceStats.initialLoadTime = performance.now();
  
  // Report to console for debugging
  console.log("Initial page load time: " + window.flutterWebPerformanceStats.initialLoadTime + "ms");

  // Apply low-bandwidth optimizations if needed
  if (window.isLowBandwidth) {
    console.log("Low bandwidth mode active - applying optimizations");
    
    // Reduce animation durations
    document.documentElement.style.setProperty('--material-animation-duration', '0.1s');
    
    // Disable certain visual effects
    const style = document.createElement('style');
    style.textContent = `
      .flutter-app * {
        transition-duration: 0.1s !important;
        animation-duration: 0.1s !important;
        box-shadow: none !important;
      }
    `;
    document.head.appendChild(style);
  }
});

// Monitor network conditions throughout the session
setInterval(function() {
  if (navigator.connection) {
    const connection = navigator.connection;
    window.flutterWebPerformanceStats.bandwidthEstimate = connection.downlink;
    
    // Update low bandwidth flag if conditions change
    if (connection.downlink < 1.0 && !window.isLowBandwidth) {
      window.isLowBandwidth = true;
      console.log("Network conditions degraded - switching to low bandwidth mode");
    } else if (connection.downlink >= 1.0 && window.isLowBandwidth) {
      window.isLowBandwidth = false;
      console.log("Network conditions improved - switching to normal mode");
    }
  }
}, 30000); // Check every 30 seconds
