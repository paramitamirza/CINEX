from model.config import Config
from model.data_utils import CoNLLDataset, get_vocabs, UNK, NUM, LG, ENT, \
    get_glove_vocab, write_vocab, load_vocab, get_char_vocab, \
    export_trimmed_glove_vectors, get_processing_word
import sys

def main():
    """Procedure to build data

    You MUST RUN this procedure. It iterates over the whole dataset (train,
    dev and test) and extract the vocabularies in terms of words, tags, and
    characters. Having built the vocabularies it writes them in a file. The
    writing of vocabulary in a file assigns an id (the line #) to each word.
    It then extract the relevant GloVe vectors and stores them in a np array
    such that the i-th entry corresponds to the i-th word in the vocabulary.


    Args:
        config: (instance of Config) has attributes like hyper-params...

    """
    # get config and processing of words
    dir_output = "./results/" + sys.argv[4] + "/"
    config = Config(dir_output, load=False)
    processing_word = get_processing_word(lowercase=True)

    # Generators
    #dev   = CoNLLDataset(config.filename_dev, processing_word)
    #test  = CoNLLDataset(config.filename_test, processing_word)
    #train = CoNLLDataset(config.filename_train, processing_word)

    dev   = CoNLLDataset(sys.argv[1], processing_word)
    test  = CoNLLDataset(sys.argv[2], processing_word)
    train = CoNLLDataset(sys.argv[3], processing_word)

    config.filename_dev = sys.argv[1]
    config.filename_test = sys.argv[2]
    config.filename_train = sys.argv[3]
    config.filename_pred = sys.argv[2].replace(".txt", ".pred")

    config.filename_words = "./data/words_" + sys.argv[4] + ".txt"
    config.filename_chars = "./data/chars_" + sys.argv[4] + ".txt"
    config.filename_tags = "./data/tags_" + sys.argv[4] + ".txt"

    # Build Word and Tag vocab
    vocab_words, vocab_tags = get_vocabs([train, dev, test])
    vocab_glove = get_glove_vocab(config.filename_glove)

    vocab = vocab_words & vocab_glove
    vocab.add(UNK)
    vocab.add(NUM)
    vocab.add(LG)
    vocab.add(ENT)

    # Save vocab
    write_vocab(vocab, config.filename_words)
    write_vocab(vocab_tags, config.filename_tags)

    # Trim GloVe Vectors
    vocab = load_vocab(config.filename_words)
    export_trimmed_glove_vectors(vocab, config.filename_glove,
                                config.filename_trimmed, config.dim_word)

    # Build and save char vocab
    train = CoNLLDataset(config.filename_train)
    vocab_chars = get_char_vocab(train)
    write_vocab(vocab_chars, config.filename_chars)


if __name__ == "__main__":
    main()
