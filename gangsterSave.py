import heapq
import os

#
# Used the following repo as the basis for working with huffman coding
# Modified it to specifically use the same format as the Gangsters Organized Crime save files
# Had to rewrite the decompression too, as it took 10 minutes, and was missing bytes at the end of the file
#   https://github.com/bhrigu123/huffman-coding/tree/master
#
# Also used the following other references
#   https://www.geeksforgeeks.org/huffman-coding-greedy-algo-3/
#   https://en.wikipedia.org/wiki/Huffman_coding
#


class GangstersSave:

    def __init__(self, path):
        self.path = path
        self.heap = []
        self.rootNode = None
        self.codes = {}
        self.reverse_mapping = {}
        self.data = None
        self.table_bytes = bytearray()

    class dataHandler:
        def __init__(self, data):
            self.data = data
            self.cursor = 0
            self.len = len(self.data)

        def readByte(self):
            result = self.data[self.cursor]
            self.cursor += 1
            return result

    class HeapNode:
        def __init__(self, symbol, freq, left=None, right=None):
            self.symbol = symbol
            self.freq = freq
            self.left = None
            self.right = None
        
        def __lt__(self, next):
            return self.freq < next.freq
        
        def __eq__(self, next):
            if (next == None):
                return False
            if (not isinstance(next, HeapNode)):
                return False
            return self.freq == next.freq
        
    def make_frequency_dict(self, data):
        frequency = {}
        for symbol in data:
            if symbol not in frequency:
                frequency[symbol] = 0
            frequency[symbol] += 1
        return frequency
    
    def make_heap(self, frequency):
        for symbol in frequency:
            node = self.HeapNode(symbol, frequency[symbol])
            heapq.heappush(self.heap, node)

    def merge_nodes(self):
        while(len(self.heap) > 1):
            left = heapq.heappop(self.heap)
            right = heapq.heappop(self.heap)

            merged = self.HeapNode(None, left.freq + right.freq)
            merged.left = left
            merged.right = right

            heapq.heappush(self.heap, merged)
        self.rootNode = heapq.heappop(self.heap)

    def make_codes_helper(self, root, current_code):
        if (root == None):
            return 

        if (root.symbol is not None):
            self.codes[root.symbol] = current_code
            self.reverse_mapping[current_code] = root.symbol
            return
        
        self.make_codes_helper(root.left, current_code + '0')
        self.make_codes_helper(root.right, current_code + '1')

    def make_codes(self):
        current_code = ""
        self.make_codes_helper(self.rootNode, current_code)

    def get_encoded_data(self, data):
        encoded_data = ""
        for byte in data:
            encoded_data += self.codes[byte]
        return encoded_data
    
    def pad_encoded_data(self, encoded_data):
        if len(encoded_data) % 8 == 0:
            return encoded_data
        extra_padding = 8 - len(encoded_data) % 8
        for i in range(extra_padding):
            encoded_data += '0'
        return encoded_data
    
    def get_byte_array(self, padded_encoded_data):
        if(len(padded_encoded_data) % 8 != 0):
            print("Encoded text not padded properly")
            exit(0)

        b = bytearray()
        for i in range(0, len(padded_encoded_data), 8):
            byte = padded_encoded_data[i:i+8]
            b.append(int(byte,2))
        return b

    def compress(self, existingTree = False):
        filename, file_extension = os.path.splitext(self.path)
        output_path = filename + ".bin"

        with open(self.path, 'rb+') as file, open(output_path, 'wb') as output:
            data = file.read()
            
            if (not existingTree or len(self.codes) == 0):
                frequency = self.make_frequency_dict(data)
                self.make_heap(frequency)
                self.merge_nodes()
                self.make_codes()

            encoded_data = self.get_encoded_data(data)
            padded_encoded_data = self.pad_encoded_data(encoded_data)

            b = self.get_byte_array(padded_encoded_data)
            output.write(bytes(self.table_bytes))
            output.write(bytes(b))

        print(f"Compressed save to {output_path}")
        return output_path
    
    def parse_save_tree(self, currNode, data):
        byte = data.readByte()
        self.table_bytes.append(byte)
        if byte > 0:
            for i in range(byte):
                direction=data.readByte()
                self.table_bytes.append(direction)
                newNode = self.HeapNode(None, None)
                if direction == 0x4c:
                    currNode.left = newNode
                    self.parse_save_tree(newNode, data)
                elif direction == 0x52:
                    currNode.right = newNode
                    self.parse_save_tree(newNode, data)
                else:
                    print("Shouldn't hit this condition!'")
                    exit()
        nextByte = data.readByte()
        self.table_bytes.append(nextByte)
        if currNode.left or currNode.right:
            return
        currNode.symbol = nextByte
        
    def make_tree_from_save(self):
        self.rootNode = self.HeapNode(None,None)
        if self.data is None:
            with open(self.path, 'rb') as fp:
                self.data = self.dataHandler(fp.read())
        else:
            self.data.cursor = 0
        
        self.parse_save_tree(self.rootNode,self.data)
        self.make_codes()

    def decode_data(self, encoded_data):
        curr_code = ""
        decoded_data = bytearray()

        for bit in encoded_data:
            curr_code += bit
            if (curr_code in self.reverse_mapping):
                symbol = self.reverse_mapping[curr_code]
                decoded_data.append(symbol)
                curr_code = ""
        return decoded_data

    def decompress(self):

        filename, file_extension = os.path.splitext(self.path)
        output_path = filename + '_decompressedv2' + file_extension

        self.make_tree_from_save()

        result = []
        currNode = self.rootNode
        while (self.data.cursor < self.data.len):
            pathData = self.data.readByte()
            bitKey = 0x80
            while bitKey != 0x00:
                if currNode.right or currNode.left:
                    if pathData & bitKey:
                        currNode = currNode.right
                    else:
                        currNode = currNode.left
                    bitKey = bitKey >> 1
                elif currNode.symbol is not None:
                    result.append(currNode.symbol)
                    currNode = self.rootNode
        with open(output_path, 'wb') as fp:
            fp.write(bytearray(result))
        print(f"Decompressed save to {output_path}")
        return output_path


if __name__ == "__main__":
    # Example of how to decompress a save
    save = GangstersSave('SampleSave.01')
    save.decompress()

    # Example of how to compress a save using an existing tree
    save = GangstersSave('SampleSave.01')  #Existing save to use the huffman tree from 
    save.make_tree_from_save()
    save.path = 'ModifiedSave.bin'         #Different, already decompressed save file to compress
    save.compress(existingTree=True)
