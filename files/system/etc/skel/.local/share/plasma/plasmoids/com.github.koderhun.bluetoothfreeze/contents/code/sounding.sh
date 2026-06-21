#!/bin/bash

# Определяем директорию, в которой находится скрипт
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# звук которого вообще не слышно
# так что есть тестовый звук для разработки
SOUND_FILE="$SCRIPT_DIR/silent.ogg"

# Устанавливаем значение по умолчанию в 2 минуты
DEFAULT_MINUTES=2

# Проверяем, передан ли аргумент
if [ $# -eq 0 ]; then
    MINUTES=$DEFAULT_MINUTES
    echo "Аргумент не указан. Используется значение по умолчанию: $DEFAULT_MINUTES минут."
else
    # Проверяем, является ли аргумент числом
    if ! [[ $1 =~ ^[0-9]+$ ]]; then
        echo "Ошибка: Аргумент должен быть положительным целым числом."
        exit 1
    fi
    MINUTES=$1
fi

# Устанавливаем интервал в секундах
INTERVAL=$((60 * MINUTES))
# Проверяем наличие команды paplay
if ! command -v paplay &> /dev/null; then
    echo "Ошибка: команда paplay не найдена. Убедитесь, что PulseAudio установлен."
    exit 1
fi

echo "Таймер установлен на $MINUTES минут ($INTERVAL секунд)"
# Основной цикл
while true; do
    echo "Воспроизводим звук"
    paplay "$SOUND_FILE"
    echo "Звук воспроизведен. Ожидание $INTERVAL секунд до следующего воспроизведения."
    sleep $INTERVAL
done
