from django.contrib import admin
from hotel.models import Hotel, Booking, ActivityLog, StaffOnDuty, Room, RoomType, HotelGallery, Coupon
from userauths.models import User, Receptionist

class HotelGalleryInline(admin.TabularInline):
    model = HotelGallery

class HotelAdmin(admin.ModelAdmin):
    inlines = [HotelGalleryInline]
    list_display = ['thumbnail', 'name', 'user', 'status']
    prepopulated_fields = {"slug": ("name", )}

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "user":
            kwargs["queryset"] = User.objects.filter(role="Receptionist")  # Chỉ lấy user có role là Receptionist
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def save_model(self, request, obj, form, change):
        # Gọi phương thức save của Hotel
        super().save_model(request, obj, form, change)

        # Cập nhật hotel của Receptionist nếu có
        if obj.user:
            receptionist = Receptionist.objects.filter(user=obj.user).first()
            if receptionist:
                receptionist.hotel = obj  # Gán hotel cho Receptionist
                receptionist.save()

        # Đảm bảo Receptionist không bị gán vào khách sạn khác
        Receptionist.objects.filter(hotel=obj).exclude(user=obj.user).update(hotel=None)

class RoomTypeAdmin(admin.ModelAdmin):
    list_display = ['type', 'hotel', 'price', 'room_capacity', 'slug']
    prepopulated_fields = {"slug": ("type", )}

class RoomAdmin(admin.ModelAdmin):
    list_display = ['hotel', 'room_type', 'room_number', 'is_available', 'rid', 'date']
    
    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "room_type":
            if request.GET.get('hotel'):
                kwargs["queryset"] = RoomType.objects.filter(hotel_id=request.GET['hotel'])  
            else:
                kwargs["queryset"] = RoomType.objects.none()  # Không có RoomType nào
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

# Đăng ký các model
admin.site.register(Hotel, HotelAdmin)
admin.site.register(Booking)
admin.site.register(ActivityLog)
admin.site.register(StaffOnDuty)
admin.site.register(Room, RoomAdmin)
admin.site.register(RoomType, RoomTypeAdmin)
admin.site.register(Coupon)
