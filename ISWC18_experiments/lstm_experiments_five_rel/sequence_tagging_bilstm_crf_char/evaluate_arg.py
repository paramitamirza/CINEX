from model.data_utils import CoNLLDataset
from model.ner_model import NERModel
from model.config import Config
import sys

def align_data(data):
    """Given dict with lists, creates aligned strings

    Adapted from Assignment 3 of CS224N

    Args:
        data: (dict) data["x"] = ["I", "love", "you"]
              (dict) data["y"] = ["O", "O", "O"]

    Returns:
        data_aligned: (dict) data_align["x"] = "I love you"
                           data_align["y"] = "O O    O  "

    """
    spacings = [max([len(seq[i]) for seq in data.values()])
                for i in range(len(data[list(data.keys())[0]]))]
    data_aligned = dict()

    # for each entry, create aligned string
    for key, seq in data.items():
        str_aligned = ""
        for token, spacing in zip(seq, spacings):
            str_aligned += token + " " * (spacing - len(token) + 1)

        data_aligned[key] = str_aligned

    return data_aligned



def interactive_shell(model):
    """Creates interactive shell to play with model

    Args:
        model: instance of NERModel

    """
    model.logger.info("""
This is an interactive mode.
To exit, enter 'exit'.
You can enter a sentence like
input> I love Paris""")

    while True:
        try:
            # for python 2
            sentence = raw_input("input> ")
        except NameError:
            # for python 3
            sentence = input("input> ")

        words_raw = sentence.strip().split(" ")

        if words_raw == ["exit"]:
            break

        preds = model.predict(words_raw)
        to_print = align_data({"input": words_raw, "output": preds})

        for key, seq in to_print.items():
            model.logger.info(seq)


def main():
    # create instance of config
    dir_output = "./results/" + sys.argv[2] + "/"
    config = Config(dir_output, load=False)

    config.filename_words = "./data/words_" + sys.argv[2] + ".txt"
    config.filename_chars = "./data/chars_" + sys.argv[2] + ".txt"
    config.filename_tags = "./data/tags_" + sys.argv[2] + ".txt"
    
    #config.dir_output = "./results/" + sys.argv[2] + "/"
    config.dir_model = config.dir_output + "model.weights/"
    config.path_log   = config.dir_output + "log.txt"

    #config.filename_dev = sys.argv[1]
    config.filename_test = sys.argv[1]
    #config.filename_train = sys.argv[3]
    config.filename_pred = sys.argv[1].replace(".txt", ".pred")    

    config.load()

    # build model
    model = NERModel(config)
    model.build()
    model.restore_session(config.dir_model)

    # create dataset
    #test  = CoNLLDataset(config.filename_test, config.processing_word,
    #                     config.processing_tag, config.max_iter)
    
    test  = CoNLLDataset(sys.argv[1], config.processing_word,
                         config.processing_tag, config.max_iter)

    # evaluate and interact
    model.evaluate(test)
    #interactive_shell(model)


if __name__ == "__main__":
    main()
