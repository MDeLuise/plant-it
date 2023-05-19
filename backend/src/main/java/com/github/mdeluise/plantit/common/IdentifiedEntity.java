package com.github.mdeluise.plantit.common;

public interface IdentifiedEntity<E> {
    E getId();

    void setId(E id);
}
