import axios, { AxiosError, AxiosInstance } from "axios";
import { botanicalInfo, plant } from "./interfaces";


export const isBigScreen = (): boolean => {
    return window.screen.width > 768;
};

export const titleCase = (string: string): string => {
    return string.charAt(0) + string.substring(1).toLowerCase().replaceAll("_", " ");
};

const readImage = (requestor: AxiosInstance, imageId: string): Promise<string> => {
    return new Promise((resolve, reject) => {
        requestor.get(`image/content${imageId}`)
            .then(res => {
                resolve(`data:application/octet-stream;base64,${res.data}`);
            })
            .catch(reject);
    });
};

const setAbsoluteImageUrl = (requestor: AxiosInstance, publicUrl: string, imageUrl?: string): Promise<string> => {
    if (imageUrl === undefined || imageUrl === null) {
        return new Promise((resolve, _reject) => resolve(`${publicUrl}botanical-info-no-img.png`));
    }
    if (imageUrl.startsWith("/")) {
        return readImage(requestor, imageUrl);
    }
    return new Promise((resolve, _reject) => resolve(imageUrl));
};

export const getPlantImg = (requestor: AxiosInstance, imageUrl?: string): Promise<string> => {
    return setAbsoluteImageUrl(requestor, process.env.PUBLIC_URL, imageUrl);
};

export const isBackendReachable = (requestor: AxiosInstance): Promise<boolean> => {
    return new Promise((resolve, _reject) => {
        requestor.get("info/ping")
            .then(_res => resolve(true))
            .catch(_err => resolve(false));
    });
};

export const getErrMessage = (err: any): string => {
    console.error(err);
    if (err.response != undefined) {
        return err.response.data.message;
    }
    if (axios.isAxiosError(err)) {
        return (err as AxiosError).message;
    }
    if (typeof (err) === "string") {
        return err.toString();
    }
    return "Some error occurred";
};


export const imgToBase64 = (url: string, callback: (arg: string) => void): void => {
    var xhr = new XMLHttpRequest();
    xhr.onload = function () {
        var reader = new FileReader();
        reader.onloadend = function () {
            callback((reader.result as string).replace("data:image/png;base64,", ""));
        };
        reader.readAsDataURL(xhr.response);
    };
    xhr.open('GET', url);
    xhr.responseType = 'blob';
    xhr.send();
};


export const fetchBotanicalInfo = (requestor: AxiosInstance, plant: plant): Promise<botanicalInfo> => {
    return new Promise<botanicalInfo>((accept, reject) => {
        requestor.get(`botanical-info/${plant.botanicalInfoId}`)
            .then(res => accept(res.data))
            .catch(reject);
    });
}


export const formatLightRequirement = (value: number | undefined, editMode: boolean): string => {
    let toReturn = "";
    if (value === undefined || value === null) {
        return "";
    } else if (value < 2) {
        toReturn = "very low";
    } else if (value < 4) {
        toReturn = "low";
    } else if (value < 6) {
        toReturn = "normal";
    } else if (value < 9) {
        toReturn = "high";
    } else {
        toReturn = "very high";
    }
    return editMode ? String(value) : `${value} (${toReturn})`;
}

export const formatHumidityRequirement = (value: number | undefined, editMode: boolean): string => {
    return formatLightRequirement(value, editMode);
}

export const formatTemperatureRequirement = (value: number | undefined, editMode: boolean): string => {
    if (value === undefined || value === null) {
        return "";
    }
    return editMode ? String(value) : value + " °C";
}

export const formatPh = (value: number | undefined) : string => {
    if (value === undefined || value === null) {
        return "";
    }
    return String(value);
}
