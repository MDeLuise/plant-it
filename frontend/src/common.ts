import { AxiosInstance } from "axios";

export const isBigScreen = (): boolean => {
    return window.screen.width > 768;
};

export const titleCase = (string: string): string => {
    return string.charAt(0) + string.substring(1).toLowerCase().replaceAll("_", " ");
};

const readImage = (requestor: AxiosInstance, imageUrl: string): Promise<string> => {
    return new Promise((resolve, reject) => {
        requestor.get(`image/content${imageUrl}`)
            .then((res) => {
                resolve(`data:application/octet-stream;base64,${res.data}`);
            });
    });
};

const setAbsoluteImageUrl = (requestor: AxiosInstance, publicUrl: string, imageUrl?: string): Promise<string> => {
    if (imageUrl == undefined) {
        return new Promise((resolve, _reject) => resolve(`${publicUrl}botanical-info-no-img.png`));
    }
    if (imageUrl.startsWith("/")) {
        return readImage(requestor, imageUrl);
    }
    return new Promise((resolve, _reject) => resolve(imageUrl));
};

export const getBotanicalInfoImg = (requestor: AxiosInstance, imageUrl?: string): Promise<string> => {
    return setAbsoluteImageUrl(requestor, process.env.PUBLIC_URL, imageUrl);
};

export const isBackendReachable = (requestor: AxiosInstance): Promise<boolean> => {
    return new Promise((resolve, _reject) => {
        requestor.get("/info/ping")
            .then((_res) => resolve(true))
            .catch((_err) => resolve(false));
    });
};
