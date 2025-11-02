const sys = @import("sys");
const std = @import("std");
const errors = @import("error");

// Re-export common ESP-IDF event types for convenience
pub const esp_event_base_t = sys.esp_event_base_t; // C string identifying an event base
pub const esp_event_loop_handle_t = sys.esp_event_loop_handle_t;
pub const esp_event_handler_t = sys.esp_event_handler_t;
pub const esp_event_handler_instance_t = sys.esp_event_handler_instance_t;
pub const esp_event_loop_args_t = sys.esp_event_loop_args_t;
pub const TickType_t = sys.TickType_t;
pub const BaseType_t = sys.BaseType_t;

// Helpers to work with event loops
pub const Loop = struct {
    pub fn create(args: [*c]const esp_event_loop_args_t, out_loop: [*c]esp_event_loop_handle_t) !void {
        return try errors.espCheckError(sys.esp_event_loop_create(args, out_loop));
    }
    pub fn delete(loop: esp_event_loop_handle_t) !void {
        return try errors.espCheckError(sys.esp_event_loop_delete(loop));
    }
    pub fn createDefault() !void {
        return try errors.espCheckError(sys.esp_event_loop_create_default());
    }
    pub fn deleteDefault() !void {
        return try errors.espCheckError(sys.esp_event_loop_delete_default());
    }
    pub fn run(loop: esp_event_loop_handle_t, ticks_to_run: TickType_t) !void {
        return try errors.espCheckError(sys.esp_event_loop_run(loop, ticks_to_run));
    }
};

// Register and unregister handlers
pub const Handler = struct {
    pub fn register(event_base: esp_event_base_t, event_id: i32, handler: esp_event_handler_t, handler_arg: ?*anyopaque) !void {
        return try errors.espCheckError(sys.esp_event_handler_register(event_base, event_id, handler, handler_arg));
    }
    pub fn registerWith(loop: esp_event_loop_handle_t, event_base: esp_event_base_t, event_id: i32, handler: esp_event_handler_t, handler_arg: ?*anyopaque) !void {
        return try errors.espCheckError(sys.esp_event_handler_register_with(loop, event_base, event_id, handler, handler_arg));
    }
    pub fn instanceRegisterWith(loop: esp_event_loop_handle_t, event_base: esp_event_base_t, event_id: i32, handler: esp_event_handler_t, handler_arg: ?*anyopaque, out_instance: [*c]esp_event_handler_instance_t) !void {
        return try errors.espCheckError(sys.esp_event_handler_instance_register_with(loop, event_base, event_id, handler, handler_arg, out_instance));
    }
    pub fn instanceRegister(event_base: esp_event_base_t, event_id: i32, handler: esp_event_handler_t, handler_arg: ?*anyopaque, out_instance: [*c]esp_event_handler_instance_t) !void {
        return try errors.espCheckError(sys.esp_event_handler_instance_register(event_base, event_id, handler, handler_arg, out_instance));
    }
    pub fn unregister(event_base: esp_event_base_t, event_id: i32, handler: esp_event_handler_t) !void {
        return try errors.espCheckError(sys.esp_event_handler_unregister(event_base, event_id, handler));
    }
    pub fn unregisterWith(loop: esp_event_loop_handle_t, event_base: esp_event_base_t, event_id: i32, handler: esp_event_handler_t) !void {
        return try errors.espCheckError(sys.esp_event_handler_unregister_with(loop, event_base, event_id, handler));
    }
    pub fn instanceUnregisterWith(loop: esp_event_loop_handle_t, event_base: esp_event_base_t, event_id: i32, instance: esp_event_handler_instance_t) !void {
        return try errors.espCheckError(sys.esp_event_handler_instance_unregister_with(loop, event_base, event_id, instance));
    }
    pub fn instanceUnregister(event_base: esp_event_base_t, event_id: i32, instance: esp_event_handler_instance_t) !void {
        return try errors.espCheckError(sys.esp_event_handler_instance_unregister(event_base, event_id, instance));
    }
};

// Posting events
pub const Post = struct {
    pub fn toDefault(event_base: esp_event_base_t, event_id: i32, event_data: ?*const anyopaque, event_data_size: usize, ticks_to_wait: TickType_t) !void {
        return try errors.espCheckError(sys.esp_event_post(event_base, event_id, event_data, event_data_size, ticks_to_wait));
    }
    pub fn toLoop(loop: esp_event_loop_handle_t, event_base: esp_event_base_t, event_id: i32, event_data: ?*const anyopaque, event_data_size: usize, ticks_to_wait: TickType_t) !void {
        return try errors.espCheckError(sys.esp_event_post_to(loop, event_base, event_id, event_data, event_data_size, ticks_to_wait));
    }
    pub fn fromISR(event_base: esp_event_base_t, event_id: i32, event_data: ?*const anyopaque, event_data_size: usize, task_unblocked: [*c]BaseType_t) !void {
        return try errors.espCheckError(sys.esp_event_isr_post(event_base, event_id, event_data, event_data_size, task_unblocked));
    }
    pub fn fromISRTo(loop: esp_event_loop_handle_t, event_base: esp_event_base_t, event_id: i32, event_data: ?*const anyopaque, event_data_size: usize, task_unblocked: [*c]BaseType_t) !void {
        return try errors.espCheckError(sys.esp_event_isr_post_to(loop, event_base, event_id, event_data, event_data_size, task_unblocked));
    }
};

pub fn dump(file: ?*std.c.FILE) !void {
    return try errors.espCheckError(sys.esp_event_dump(file));
}

// Convenience: build an esp_event_loop_args_t with sensible defaults
pub fn defaultLoopArgs(queue_size: i32, task_name: [*:0]const u8, task_priority: BaseType_t, task_stack_size: u32, task_core_id: BaseType_t) esp_event_loop_args_t {
    return .{
        .queue_size = queue_size,
        .task_name = task_name,
        .task_priority = @intCast(task_priority),
        .task_stack_size = task_stack_size,
        .task_core_id = task_core_id,
    };
}
