export const isBigScreen = (): boolean => {
    return window.screen.width > 768;
}

export const titleCase = (string: string): string => {
    return string.charAt(0) + string.substring(1).toLowerCase();
};