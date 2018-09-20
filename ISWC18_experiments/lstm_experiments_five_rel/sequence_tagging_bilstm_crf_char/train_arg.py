from model.data_utils import CoNLLDataset
from model.ner_model import NERModel
from model.config import Config
import sys

def main():
    # create instance of config
    dir_output = "./results/" + sys.argv[3] + "/"
    config = Config(dir_output, load=False)

    config.filename_words = "./data/words_" + sys.argv[3] + ".txt"
    config.filename_chars = "./data/chars_" + sys.argv[3] + ".txt"
    config.filename_tags = "./data/tags_" + sys.argv[3] + ".txt"
    
    #config.dir_output = "./results/" + sys.argv[3] + "/"
    config.dir_model = config.dir_output + "model.weights/"
    config.path_log   = config.dir_output + "log.txt"

    config.filename_dev = sys.argv[1]
    #config.filename_test = sys.argv[2]
    config.filename_train = sys.argv[2]

    config.load()

    # build model
    model = NERModel(config)
    model.build()
    # model.restore_session("tmp/model.weights/") # optional, restore weights

    # create datasets
    #dev   = CoNLLDataset(config.filename_dev, config.processing_word,
    #                     config.processing_tag, config.max_iter)
    #train = CoNLLDataset(config.filename_train, config.processing_word,
    #                     config.processing_tag, config.max_iter)

    dev   = CoNLLDataset(sys.argv[1], config.processing_word,
                         config.processing_tag, config.max_iter)
    train = CoNLLDataset(sys.argv[2], config.processing_word,
                         config.processing_tag, config.max_iter)
    config.filename_pred = sys.argv[1].replace(".txt", ".pred")

    # train model
    model.train(train, dev)

if __name__ == "__main__":
    main()
