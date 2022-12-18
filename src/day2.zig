const std = @import("std");
const print = std.debug.print;
const eql = std.mem.eql;

// Day input
const day_content = @embedFile("inputs/day2.input");

pub fn run() void {
    const wrong = playGame(day_content, false);
    print("Points with first approach: {}\n", .{wrong});
    const correct = playGame(day_content, true);
    print("Points with first approach: {}\n", .{correct});
}

fn playGame(content: []const u8, correct: bool) usize {
    var lines = std.mem.split(u8, std.mem.trimRight(u8, content, "\n"), "\n");
    var sum: usize = 0;
    while (lines.next()) |line| {
        var game = if (correct) Game.createCorrect(line) else Game.createWrong(line);
        game.setOutcome();
        sum += @enumToInt(game.player) + @enumToInt(game.outcome);
    }
    return sum;
}

const Play = enum(u8) {
    rock = 1,
    paper = 2,
    scissor = 3,

    const Self = @This();

    fn simplePlay(value: []const u8) Self {
        if (eql(u8, value, "A") or eql(u8, value, "X")) return Self.rock;
        if (eql(u8, value, "B") or eql(u8, value, "Y")) return Self.paper;
        if (eql(u8, value, "C") or eql(u8, value, "Z")) return Self.scissor;
        unreachable;
    }
    fn complexPlay(value: []const u8) Self {
        if (eql(u8, value, "A Y") or eql(u8, value, "B X") or eql(u8, value, "C Z")) return Self.rock;
        if (eql(u8, value, "A Z") or eql(u8, value, "B Y") or eql(u8, value, "C X")) return Self.paper;
        if (eql(u8, value, "A X") or eql(u8, value, "B Z") or eql(u8, value, "C Y")) return Self.scissor;
        unreachable;
    }
};

const Outcome = enum(u8) {
    lose = 0,
    draw = 3,
    win = 6,
};

const Game = struct {
    elf: Play,
    player: Play,
    outcome: Outcome = undefined,

    const Self = @This();

    fn createWrong(line: []const u8) Self {
        var it = std.mem.split(u8, line, " ");
        const elf = it.next().?;
        const player = it.next().?;
        return Self{
            .elf = Play.simplePlay(elf),
            .player = Play.simplePlay(player),
        };
    }

    fn createCorrect(line: []const u8) Self {
        var it = std.mem.split(u8, line, " ");
        const elf = it.next().?;
        return Self{
            .elf = Play.simplePlay(elf),
            .player = Play.complexPlay(line),
        };
    }

    fn setOutcome(self: *Self) void {
        const outcome: Outcome = switch (self.player) {
            .rock => if (self.elf == .rock) Outcome.draw else if (self.elf == .paper) Outcome.lose else Outcome.win,
            .paper => if (self.elf == .rock) Outcome.win else if (self.elf == .paper) Outcome.draw else Outcome.lose,
            .scissor => if (self.elf == .rock) Outcome.lose else if (self.elf == .paper) Outcome.win else Outcome.draw,
        };
        self.outcome = outcome;
    }
};

const test_content = @embedFile("inputs/day2.test");

test "test playGame wrong" {
    const sum = playGame(test_content, false);
    try std.testing.expectEqual(@as(usize, 15), sum);
}

test "test playGame correct" {
    const sum = playGame(test_content, true);
    try std.testing.expectEqual(@as(usize, 12), sum);
}

test "test game setOutcome" {
    var game = Game{
        .elf = Play.rock,
        .player = Play.paper,
    };
    game.setOutcome();
    try std.testing.expectEqual(Outcome.win, game.outcome);
    game.elf = Play.scissor;
    game.setOutcome();
    try std.testing.expectEqual(Outcome.lose, game.outcome);
    game.player = Play.scissor;
    game.setOutcome();
    try std.testing.expectEqual(Outcome.draw, game.outcome);
}

test "test game createWrong" {
    var line = "A X";
    var game = Game.createWrong(line);
    try std.testing.expectEqual(Play.rock, game.player);
    try std.testing.expectEqual(Play.rock, game.elf);
    line = "B Z";
    game = Game.createWrong(line);
    try std.testing.expectEqual(Play.paper, game.elf);
    try std.testing.expectEqual(Play.scissor, game.player);
}

test "test game createCorrect" {
    var line = "A X";
    var game = Game.createCorrect(line);
    try std.testing.expectEqual(Play.scissor, game.player);
    try std.testing.expectEqual(Play.rock, game.elf);
    line = "B Z";
    game = Game.createCorrect(line);
    try std.testing.expectEqual(Play.paper, game.elf);
    try std.testing.expectEqual(Play.scissor, game.player);
}

test "test play simplePlay" {
    var line = "A";
    try std.testing.expectEqual(Play.rock, Play.simplePlay(line));
    line = "X";
    try std.testing.expectEqual(Play.rock, Play.simplePlay(line));
    line = "C";
    try std.testing.expectEqual(Play.scissor, Play.simplePlay(line));
}

test "test play complexPlay" {
    var line = "A Z";
    try std.testing.expectEqual(Play.paper, Play.complexPlay(line));
    line = "C X";
    try std.testing.expectEqual(Play.paper, Play.complexPlay(line));
    line = "B X";
    try std.testing.expectEqual(Play.rock, Play.complexPlay(line));
}
