const selectId = () => {

    const { floor, random } = Math;

    function generateUpperCaseLetter() {
        return randomCharacterFromArray('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    }

    function generateLowerCaseLetter() {
        return randomCharacterFromArray('abcdefghijklmnopqrstuvwxyz');
    }

    function generateNumber() {
        return randomCharacterFromArray('1234567890');
    }

    function randomCharacterFromArray(array) {
        return array[floor(random() * array.length)];
    }


    function generateIdentifier(identifiers) {
        const identifier = [
            ...Array.from({ length: 2 }, generateUpperCaseLetter),
            ...Array.from({ length: 3 }, generateNumber),
            ...Array.from({ length: 4 }, generateLowerCaseLetter),
            ...Array.from({ length: 2 }, generateUpperCaseLetter),
            ...Array.from({ length: 2 }, generateNumber),
        ].join('');
        return identifiers.includes(identifier) ? generateIdentifier() : identifiers.push(identifier), identifier;
    }

    return generateIdentifier;
}

module.exports = selectId