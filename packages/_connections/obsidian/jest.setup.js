// Mock DOM environment
document.body.createEl = function(tag, attrs = {}) {
    const el = document.createElement(tag);
    if (attrs.text) el.textContent = attrs.text;
    if (attrs.cls) el.className = attrs.cls;
    if (attrs.attr) {
        Object.entries(attrs.attr).forEach(([key, value]) => {
            el.setAttribute(key, value);
        });
    }
    return el;
};

// Mock Obsidian API
global.app = {
    vault: {
        adapter: {
            basePath: '/mock/vault/path',
            mkdir: jest.fn().mockResolvedValue(undefined),
        }
    }
};

// Mock child_process exec
jest.mock('child_process', () => ({
    exec: jest.fn(),
    promisify: jest.fn().mockReturnValue(jest.fn())
}));

// Mock Notice
global.Notice = jest.fn();
