Received: from mail-dy2-f12.google.com (mail-dy2-f12.google.com [74.125.229.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3093D34DB41
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Sep 2026 09:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413514; cv=none; b=V5Yfo/wAm3amoCRXzClworKLAQu/4bFvPcj559JhAlDsu/JVygXXFPQg6c07qvDqdNN3n2NhOFVM78f3ibckQrkRb18JtCsjJw+P3e5Degj8Gcv/6C1DzpcMyhz6g63aK4YqHpU6kJILxKEtI52/PUDx09Zgt+A9q3WZP9uTUXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413514; c=relaxed/simple;
	bh=u0d0iwMmRf2bwy3hyCtvUDQ110niZFIFIGYBbc1tKZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcCYa33lO5AWPOZqNv9cRGt1Os82R857LRmznaxZtG+FK7eDQ0Z+xduEJyF0tW7ujObEzOsVE04YAFTzAcJKoKMxkFdL7FgNjT18KxCDmTTmwAXVgO4Eryz8shdjftCoZ/+TmYSSdLTj03hhsH6FIjOZOO/RU0kVMsRYZXD8vGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VedZR9D+; arc=none smtp.client-ip=74.125.229.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VedZR9D+"
Received: by mail-dy2-f12.google.com with SMTP id 5a478bee46e88-33be7dfcfc1so2185891eec.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 26 Sep 2026 02:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790413511; x=1791018311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zCUHK9sgpCLsAEsDfBOc3OBxNGg6PKX8t4XYYKy3oeA=;
        b=VedZR9D+yCM7LgIs58oc5OoCJSFoH693+1vJzPN7Z2W+uND2o3LzsOG8OsDjCfUivn
         PozPQHEXdwExr6UnTJJyPvbr29ko0uy4Met3zBvyqyGzGdlVcIdRFMSp3qvOI2BLq6Ua
         HcPY6XFMUnC5NwxzsjcE3U+T363uSTViGmPdvmVD3dG8ZEYF+0hbj/SMD3GTPJ/ydQUi
         tf1Lk4aWvUw/q3m+T7juZPco3npem9HszDZCUObv9jyorKSccfVe0jPF6EwwYoL1XzOX
         Inh8u7slldKs9enmFu3GdAE2CwZkH1xwhKEeIW3dSNBLsPawev+pCPFudQpcu1L9fg8Q
         bl+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790413511; x=1791018311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zCUHK9sgpCLsAEsDfBOc3OBxNGg6PKX8t4XYYKy3oeA=;
        b=boVW+OXO9fH6QdDn9S3mAqRxHbgRbuM8cLaxkBgXrhXutfPgfMP7GnFWvnQ51ZaRl0
         u7Hs2LU42Ud2doMxo3YC3X/OaKI3T0iEno5WHNIbFc+U2GzlMr5iRQtjIBGkYQeV0Uy/
         igmWkMPJt1q9jfncnrSVbgz2Ws39WRgJL/QSvDJb5RcoTQDmbY5GAc9WOvM35x8L7Vdq
         qGTTo8k3UnfS/WFzqJRNRCsULDR10pJMf8y+fhh7sw5lxZFYF9gPO+9FyNQq/7D+4WnY
         /JuP2QiHBLzhenlnwWufaojAwo25q4HYqfJgY3ogqq0632BNrtUQ83jVp0tb47v1tm8A
         u5Uw==
X-Gm-Message-State: AFq9FYJ1GQgm07iWr2W5HV0/Uhx/hTvnELYp8WvqJ7tPeK0EmymQ6qEF
	m44KoSx8ufZqPwQ9V9t53BD/Io9BbUty8Pbgct/Sliifz8YgiCeMu7E22btxubWF89xIhAZv
X-Gm-Gg: AYBFou1ha7YmiXMFJlzXdxveJkMcYl+jHFh0FavRLD4yLDTCE5vNV4dhBxq0wFsPqzI
	l7gkrNZK/pLvenMs4UrwpGGFa7PqKBideKlodRJBMeiOLSvcmG0kJDw53n3boYifI0xy1S6Mlb8
	LC+JEp/jsgzaSKm/BKg/kuH2uelxIPRtR2k7udDYfhrq84b6GHLLRYQGMgH2JLRyHwXvZxuQVMJ
	FFMaBnKGQwpcn7fmeAOoRaSTkuMwLLRz1pgYIHcISq8Uv4+sVqShfHvn7j3xmg0uvwJw+mKxg1t
	0dvjc3GN6Nfk3DYq/bWGICvmU2kfulGjq+k5Ztjc8TFV8dX4mpnF/nncsW6HSHJwed7Gs9BtpIH
	qPO28ZgjMU8BmLG6WVzETM+hbp16jrOVmL4F2jI7O0fvFD7rf8yNPIeB8QbIJREGhyfl+YEX4J7
	+TTJHOCR3r86ateEBxKLD9/VdKIrbwAbzCrWODl/2/dTPB5lkiG8nIiDWlO9hBJxs9XPloCykF8
	xQDSwVWFunWlkIHQQP5aoHyUOEgG4WpUSNAxeuvgXzXMAo5+vkx9m6ODI7WZPW9r9YVOPJG1M0E
	pRTaidWx8N3VDleDLnbKmRjFePf9JXowK1LVdZ77GWdM74xtVmfvq6puPko=
X-Received: by 2002:a05:7300:d192:b0:340:6c8:50e0 with SMTP id 5a478bee46e88-3426fbbe360mr2398112eec.2.1790413510929;
        Sat, 26 Sep 2026 02:05:10 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm5058901eec.11.2026.09.26.02.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 02:05:10 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>
Subject: [RFC PATCH] bcachefs: test bitmap GC crash durability
Date: Sat, 26 Sep 2026 17:05:07 +0800
Message-ID: <20260926090507.605237-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926090358.603911-1-matthias.goergens@gmail.com>
References: <20260926090358.603911-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create a two-device filesystem and begin evacuating one member, then
hold btree-node and journal writes on both devices with dm-delay. This
leaves real interior updates in flight while the old nodes remain
reachable on disk.

Run bitmap GC in that window and copy the lower devices before
releasing the writes. Copy them again after the pass returns. Offline
fsck must accept both crash images without finding reachable btree nodes
outside the member bitmap.

The no-GC case takes the same held crash image as a timing-matched
negative control.

On upstream testing the GC case fails both fsck checks, while the no-GC
control passes. Both images pass with the bitmap GC durability fix.

Release held writes in the failure cleanup path before unmounting, so an
early assertion reports its original failure instead of waiting for the
test watchdog.

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 tests/fs/bcachefs/btree-bitmap-gc-crash.ktest | 308 ++++++++++++++++++
 1 file changed, 308 insertions(+)
 create mode 100755 tests/fs/bcachefs/btree-bitmap-gc-crash.ktest

diff --git a/tests/fs/bcachefs/btree-bitmap-gc-crash.ktest b/tests/fs/bcachefs/btree-bitmap-gc-crash.ktest
new file mode 100755
index 0000000..c27d116
--- /dev/null
+++ b/tests/fs/bcachefs/btree-bitmap-gc-crash.ktest
@@ -0,0 +1,308 @@
+#!/usr/bin/env bash
+#
+# Online btree bitmap GC versus interior updates that are not yet durable.
+#
+# The member btree_allocated_bitmap must cover every btree node that can be
+# reachable after a crash. btree_bitmap_gc rebuilds it from the in-memory
+# btree topology and then replaces the on-disk bitmap with the result. An
+# interior update changes the in-memory topology as soon as its new nodes are
+# allocated, but the old nodes stay reachable on disk until the new nodes have
+# been written and the parent update has been journalled.
+#
+# These tests hold btree node and journal writes (but not superblock writes)
+# behind dm-delay while a device is being evacuated. A lower linear mapping
+# can be suspended without flushing the delayed writes, so copies of the raw
+# devices are what a crash at that moment would leave behind. Offline fsck of
+# the copies must not find reachable btree nodes outside the bitmap.
+#
+# test_btree_bitmap_gc_crash requires bitmap GC to wait for the held update,
+# checks a crash image from that window, releases the writes, then checks a
+# second crash image taken after GC publishes the new bitmap;
+# test_btree_bitmap_gc_crash_no_gc takes the identical crash image without
+# running bitmap GC, as a control for the crash image itself.
+
+# shellcheck source=tests/fs/bcachefs/bcachefs-test-libs.sh
+# shellcheck disable=SC1091
+. "$(dirname "$(readlink -e "${BASH_SOURCE[0]}")")/bcachefs-test-libs.sh"
+
+require-kernel-config DM_DELAY
+
+config-scratch-devs 2G
+config-scratch-devs 2G
+config-scratch-devs 2G
+config-scratch-devs 2G
+config-scratch-devs 2G
+config-scratch-devs 2G
+config-timeout 600
+
+# Long enough to never expire during the test; held bios are released
+# explicitly by swapping the table back.
+bitmap_gc_hold_ms=600000
+bitmap_gc_bucket_sectors=1024
+bitmap_gc_observation_seconds=60
+
+bitmap_gc_dm_linear()
+{
+    local name=$1 dev=$2
+    local sz
+    sz=$(blockdev --getsz "$dev")
+
+    dmsetup reload "$name" --table "0 $sz linear $dev 0"
+    dmsetup suspend --nolockfs "$name"
+    dmsetup resume "$name"
+}
+
+# Hold every write outside the superblock copies. Flushes are not delayed, so
+# superblock writes (which are submitted with preflush) still complete.
+bitmap_gc_dm_hold()
+{
+    local name=$1 dev=$2 start=$3 end=$4
+    local sz
+    sz=$(blockdev --getsz "$dev")
+    local table="0 $start linear $dev 0
+$start $((end - start)) delay $dev $start 0 $dev $start $bitmap_gc_hold_ms $dev $start 0"
+
+    (( end < sz )) && table+="
+$end $((sz - end)) linear $dev $end"
+
+    dmsetup reload "$name" --table "$table"
+    dmsetup suspend --nolockfs "$name"
+    dmsetup resume "$name"
+}
+
+bitmap_gc_inflight_updates()
+{
+    grep -c '^mode=' "/sys/kernel/debug/bcachefs/$1/btree_updates" || true
+}
+
+bitmap_gc_snapshot()
+{
+    local lower0=$1 lower1=$2 dev0=$3 dev1=$4 copy0=$5 copy1=$6
+    local ret=0
+
+    # Suspending dm-delay would release its queued bios. Suspend the lower
+    # linear targets instead, without a flush, so both raw devices stay fixed
+    # while they are copied and the delayed bios remain queued above them.
+    echo "snapshot: suspending $lower0 and $lower1"
+    dmsetup suspend --noflush --nolockfs "$lower0" "$lower1"
+    echo "snapshot: copying $dev0 to $copy0"
+    dd if="$dev0" of="$copy0" bs=4M iflag=direct oflag=direct status=none || ret=$?
+    echo "snapshot: copying $dev1 to $copy1"
+    dd if="$dev1" of="$copy1" bs=4M iflag=direct oflag=direct status=none || ret=$?
+    echo "snapshot: resuming $lower0 and $lower1"
+    dmsetup resume --noflush --nolockfs "$lower0" "$lower1"
+    echo "snapshot: complete"
+    return $ret
+}
+
+bitmap_gc_check_crash_copy()
+{
+    local label=$1 copy0=$2 copy1=$3
+    local log=/tmp/bitmap-gc-fsck-$label.txt ret=0
+
+    bcachefs show-super -f members_v2 "$copy1" |
+	grep -i -A1 'btree allocated bitmap' || true
+    bcachefs fsck -n "$copy0" "$copy1" > "$log" 2>&1 || ret=$?
+    cat "$log"
+    echo "fsck of $label crash image returned $ret"
+
+    if grep -q 'not marked in member info btree allocated bitmap' "$log"; then
+	echo "FAILED: $label crash image has reachable btree nodes outside the btree allocated bitmap"
+	return 1
+    fi
+    (( ret == 0 ))
+}
+
+bitmap_gc_cleanup()
+{
+    set +e
+    dmsetup resume --noflush --nolockfs bitmapgcbase0 bitmapgcbase1 \
+	>/dev/null 2>&1
+    # Release any queued writes before unmounting.  A failure between
+    # installing the delay tables and the normal release path otherwise
+    # leaves umount waiting for bitmap_gc_hold_ms.
+    bitmap_gc_dm_linear bitmapgc0 /dev/mapper/bitmapgcbase0 \
+	>/dev/null 2>&1
+    bitmap_gc_dm_linear bitmapgc1 /dev/mapper/bitmapgcbase1 \
+	>/dev/null 2>&1
+    umount /mnt >/dev/null 2>&1
+    dmsetup remove --retry bitmapgc0 bitmapgc1 >/dev/null 2>&1
+    dmsetup remove --retry bitmapgcbase0 bitmapgcbase1 >/dev/null 2>&1
+}
+
+bitmap_gc_crash_test()
+{
+    local run_gc=$1
+    # Populated by config-scratch-devs in the ktest runner.
+    # shellcheck disable=SC2154
+    local dev0=${ktest_scratch_dev[0]} dev1=${ktest_scratch_dev[1]}
+    local copy0=${ktest_scratch_dev[2]} copy1=${ktest_scratch_dev[3]}
+    local post_copy0=${ktest_scratch_dev[4]} post_copy1=${ktest_scratch_dev[5]}
+    local lower0=bitmapgcbase0 lower1=bitmapgcbase1
+    local base0=/dev/mapper/$lower0 base1=/dev/mapper/$lower1
+    local mnt0=/dev/mapper/bitmapgc0 mnt1=/dev/mapper/bitmapgc1
+
+    set_watchdog 400
+    modprobe dm-delay
+    # run_test_isolated() installs the descendant cleanup. Add mapper cleanup
+    # while this test owns them, and restore the original handler on success.
+    trap 'bitmap_gc_cleanup; kill_descendants $BASHPID' EXIT
+
+    dmsetup create "$lower0" --table "0 $(blockdev --getsz "$dev0") linear $dev0 0"
+    dmsetup create "$lower1" --table "0 $(blockdev --getsz "$dev1") linear $dev1 0"
+    dmsetup create bitmapgc0 --table "0 $(blockdev --getsz "$base0") linear $base0 0"
+    dmsetup create bitmapgc1 --table "0 $(blockdev --getsz "$base1") linear $base1 0"
+
+    run_quiet "" bcachefs format -f \
+	--bucket_size=$((bitmap_gc_bucket_sectors * 512)) \
+	--metadata_replicas=1 --data_replicas=1 \
+	"$mnt0" "$mnt1"
+    mount -t bcachefs -o noreconcile_enabled "$mnt0:$mnt1" /mnt
+
+    local uuid='' entry
+    for entry in /sys/fs/bcachefs/*; do
+	[[ ${entry##*/} =~ ^[0-9a-f-]{36}$ ]] || continue
+	if [[ -n $uuid ]]; then
+	    echo "FAILED: multiple mounted bcachefs filesystems" >&2
+	    return 1
+	fi
+	uuid=${entry##*/}
+    done
+    [[ -n $uuid ]]
+    local fs_sysfs=/sys/fs/bcachefs/$uuid
+    mountpoint -q /sys/kernel/debug || mount -t debugfs debugfs /sys/kernel/debug
+
+    # A new filesystem already has many btree nodes on both devices, since
+    # several btrees are presplit at format time. Keep it free of file data,
+    # so evacuating the second device is purely btree node rewrites.
+    sync -f /mnt
+
+    bcachefs fs usage -h /mnt
+
+    # Superblock copies: the first two are adjacent at the start of the
+    # device, spaced by the maximum superblock size; any further copy is at
+    # the end. Hold everything in between.
+    local offsets_text
+    offsets_text=$(bcachefs show-super --layout "$mnt1" |
+	awk -F: '/Offsets:/ { gsub(/,/, " ", $2); print $2; exit }')
+    local -a offsets=()
+    read -r -a offsets <<< "$offsets_text"
+    (( ${#offsets[@]} >= 2 ))
+    local sb_size=$((offsets[1] - offsets[0]))
+    local hold_start=$((offsets[1] + sb_size))
+    local hold_end
+    hold_end=$(blockdev --getsz "$dev1")
+    (( ${#offsets[@]} > 2 )) && hold_end=${offsets[-1]}
+    echo "superblocks at ${offsets[*]}, holding writes to sectors $hold_start-$hold_end"
+
+    # Mark the second device for evacuation with reconcile off, then remount
+    # so that no journal entry still needed for replay lives on it (journal
+    # read skips devices that are being evacuated).
+    bcachefs device set-state ro "$mnt1"
+    bcachefs device set-state evacuating "$mnt1"
+    umount /mnt
+    mount -t bcachefs -o noreconcile_enabled "$mnt0:$mnt1" /mnt
+
+    bitmap_gc_dm_hold bitmapgc0 "$base0" "$hold_start" "$hold_end"
+    bitmap_gc_dm_hold bitmapgc1 "$base1" "$hold_start" "$hold_end"
+
+    echo 1 > "$fs_sysfs/options/reconcile_enabled"
+    echo 1 > "$fs_sysfs/internal/trigger_reconcile_wakeup"
+
+    # Wait for node rewrites to be in flight, stuck on their held writes:
+    local n=0 prev=-1 stable=0
+    for _ in $(seq 1 60); do
+	n=$(bitmap_gc_inflight_updates "$uuid")
+	if (( n > 0 && n == prev )); then
+	    stable=$((stable + 1))
+	    (( stable >= 3 )) && break
+	else
+	    stable=0
+	fi
+	prev=$n
+	sleep 1
+    done
+    echo "interior updates in flight: $n"
+    cat "/sys/kernel/debug/bcachefs/$uuid/btree_updates"
+    (( n > 0 ))
+
+    local gc_pid='' premature_publication=0
+    if (( run_gc )); then
+	# A safe implementation blocks before publishing the bitmap. The
+	# unpatched implementation publishes, prints its completion line, then
+	# blocks in the recovery runner's journal flush.
+	bcachefs fsck -o recovery_passes=btree_bitmap_gc /mnt > /tmp/bitmap-gc-online.txt 2>&1 &
+	gc_pid=$!
+	for _ in $(seq 1 60); do
+	    grep -q 'Currently running:.*btree_bitmap_gc' "$fs_sysfs/recovery_status" && break
+	    sleep 1
+	done
+	cat "$fs_sysfs/recovery_status"
+	grep -q 'Currently running:.*btree_bitmap_gc' "$fs_sysfs/recovery_status"
+	kill -0 "$gc_pid"
+
+	# Give an implementation that incorrectly publishes before waiting a
+	# bounded chance to reach the observable completion point. Keep waiting
+	# after observing it so the crash cut matches the no-GC control's age.
+	for _ in $(seq 1 $bitmap_gc_observation_seconds); do
+	    if grep -q 'mi_btree_bitmap sectors' /tmp/bitmap-gc-online.txt; then
+		premature_publication=1
+	    fi
+	    sleep 1
+	done
+    else
+	# Timing-matched negative control for the held crash image.
+	sleep $bitmap_gc_observation_seconds
+    fi
+
+    # First crash point: the old topology is still durable. Bitmap GC must
+    # not have published a bitmap which omits it.
+    bitmap_gc_snapshot "$lower0" "$lower1" "$dev0" "$dev1" "$copy0" "$copy1"
+    if (( run_gc )); then
+	cat /tmp/bitmap-gc-online.txt
+	if grep -q 'mi_btree_bitmap sectors' /tmp/bitmap-gc-online.txt; then
+	    premature_publication=1
+	    echo "FAILED: bitmap GC published while an interior update was held"
+	else
+	    echo "bitmap GC is still waiting with the interior update held"
+	fi
+    fi
+
+    bitmap_gc_dm_linear bitmapgc0 "$base0"
+    bitmap_gc_dm_linear bitmapgc1 "$base1"
+    if [[ -n $gc_pid ]]; then
+	wait "$gc_pid"
+	cat /tmp/bitmap-gc-online.txt
+	grep -q 'mi_btree_bitmap sectors' /tmp/bitmap-gc-online.txt
+
+	# Second crash point: the pass returned only after making the observed
+	# topology durable, then publishing its replacement bitmap.
+	bitmap_gc_snapshot "$lower0" "$lower1" "$dev0" "$dev1" "$post_copy0" "$post_copy1"
+    fi
+
+    umount /mnt
+    dmsetup remove --retry bitmapgc0
+    dmsetup remove --retry bitmapgc1
+    dmsetup remove --retry "$lower0" "$lower1"
+    trap 'kill_descendants $BASHPID' EXIT
+
+    local held_ret=0
+    bitmap_gc_check_crash_copy held "$copy0" "$copy1" || held_ret=$?
+    if (( run_gc )); then
+	bitmap_gc_check_crash_copy completed "$post_copy0" "$post_copy1"
+	(( premature_publication == 0 ))
+    fi
+    (( held_ret == 0 ))
+}
+
+test_btree_bitmap_gc_crash()
+{
+    bitmap_gc_crash_test 1
+}
+
+test_btree_bitmap_gc_crash_no_gc()
+{
+    bitmap_gc_crash_test 0
+}
+
+main "$@"
