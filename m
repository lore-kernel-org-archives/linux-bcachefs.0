Received: from e234-6.smtp-out.ap-northeast-1.amazonses.com (e234-6.smtp-out.ap-northeast-1.amazonses.com [23.251.234.6])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3567713957E
	for <linux-bcachefs@vger.kernel.org>; Sun,  4 Oct 2026 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791126377; cv=none; b=JlbDuf6zz+WYizF1fen0/RsiKgZQzMOdGqOnWuzhwE8xL4v4JhqsuDlxvGJPCGTwQMuzC2Tsrdn+eGvxyCVJAXpB+ZqElCl6xc3sQRyVZtmNO9N30FjkCqya8OF1YGgnzZ/H5wReHlDoq0wBJtPCjmX7EeS1xEAdQcG+4vWg5zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791126377; c=relaxed/simple;
	bh=1DvRqm/tHCgxaG2hzP2z/BvIlQvC2QE/Q4YuvrErVCE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SrVmV/VeE5KFbvwmhuO8NKUjKGzaSxPDigDZbm5mkJFV052/zTsKeXJXyJ7oxkIoR4Ic7T2hOYcYo0zEgEmT5BmMqsP/kOz7OHtrqDr9LYwdWFDU1YhqjfWECU+SxfhhV+dwTQowLqphExhNBUqluz+jrGw1Ia3L+OGMi+D2acs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=xx-co.com; spf=pass smtp.mailfrom=ap-northeast-1.amazonses.com; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=rhhPFqNj; arc=none smtp.client-ip=23.251.234.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=xx-co.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ap-northeast-1.amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="rhhPFqNj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=zh4gjftm6etwoq6afzugpky45synznly; d=amazonses.com; t=1791126374;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
	bh=1DvRqm/tHCgxaG2hzP2z/BvIlQvC2QE/Q4YuvrErVCE=;
	b=rhhPFqNjLuKoV1XfGo2OjkfNHv8vWEwyxildoEdRhxs9hNSGriiPoLB3RPaRHf9M
	lRErHCStfblzkB2D6n340GSyU1LcB5VofCso98BA5ceCENS8VU4JzVYOO5P9lNyN703
	LO3BxDFGhQ98sOHk++43ezD3sQB8e5T/X3nGa87o=
Authentication-Results: auth=pass smtp.mailfrom=daniel@xx-co.com; 
From: Daniel Suek <daniel@xx-co.com>
To: linux-bcachefs@vger.kernel.org
Subject: [RFC] bcachefs: page-level processing layer to eliminate sub-extent read amplification
Date: Sun, 4 Oct 2026 15:06:13 +0000
Message-ID: <010601a10773864f-29ea0d0b-b2d6-421f-9849-65c55da3c277-000000@ap-northeast-1.amazonses.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Feedback-ID: ::1.ap-northeast-1.cYIZLOjIwdEH/pNWTsToOXtmOZyQLzRgwCOPQvNJAds=:AmazonSES
X-SES-Outgoing: 2026.10.04-23.251.234.6

Random 4KB reads on checksummed extents bounce the full 256KiB
extent — 64x device I/O amplification (bcachefs-tools#980).
This affects database, VM, and metadata-heavy workloads on NVMe.
Sequential reads are unaffected; readahead masks the cost.

The root cause is that the extent is the atomic unit for both
data processing and I/O, with no layer boundary between them.
A sub-extent read must bounce the whole extent, verify, then
copy out one page and discard the rest.

This coupling originates from HDD seek amortization — once the
head has seeked, processing a full extent costs little more
than one page. On NVMe, 4KB is the native read unit and that
rationale no longer applies. Extents still serve metadata
compaction (one btree key per extent) and write amplification
reduction, so this proposal keeps extents for allocation.

None of the main processing consumers — checksum, encryption,
compression — structurally requires extent-level batching.
Each decomposes to page granularity:

CRC32c is composable over GF(2). Per-page CRCs compose to the
whole-extent CRC exactly; bch2_checksum_merge() already exists.

ChaCha20 is counter-mode. A per-page nonce is derivable from
the extent nonce + page offset; nonce_add() already exists.

Poly1305 authentication is the harder piece — the current MAC
covers the full extent. Per-page authentication requires
per-page MAC tags, a format change deferred to a later step.
The first implementation (CRC32c only) sidesteps this.

Other checksum types: CRC64 is also GF(2)-composable and
follows the same approach. Non-composable types (xxhash) fall
back to the current extent-level path.

Compression has a data dependency between pages — the sliding
window references preceding decompressed output. This is not a
batching requirement but a dictionary requirement. Solutions
exist (trained per-inode dictionaries, page-cache-as-dictionary)
but the design choice is deferred; compressed extents stay on
the current bounce path.

Erasure coding operates cross-device, independent of
within-device page size. No change needed.

The proposal is to separate two concerns that the extent
currently combines:

A processing layer, where checksum, encryption, and eventually
compression operate at page granularity. Each page is
independently verifiable and decryptable. This is the layer
that eliminates read amplification — a sub-extent read
processes only the requested page.

An amortization layer, where I/O is batched to match device
characteristics. This layer is device-aware and
processing-independent: it decides how much to read from disk,
not how to verify or decrypt what was read.

On NVMe, 4KB random reads are native. The block layer's bio
merging already handles sequential batching. No additional
filesystem-level amortization is needed.

On HDD, seek cost still dominates and batched I/O remains
essential. The block layer provides readahead and bio merging,
but whether that is sufficient or the filesystem needs its own
device-aware batching is an open question (see below).

Extents remain as allocation metadata — contiguous block
run-length encoding. They continue to serve metadata compaction
and write amplification reduction. What changes is that
processing no longer requires reading at extent granularity.

InnoDB has had per-page checksum/encrypt/compress for decades,
with extents as allocation-only units and a buffer pool as its
amortization layer. An architectural precedent, though not a
direct analogy: InnoDB embeds checksums in page headers (zero
indirection); this proposal uses an external btree.

btrfs CSUM_TREE decouples checksums from extents but not
encryption or compression. No production POSIX filesystem has
per-page checksum and encryption decoupled from extent
boundaries.

As a first step, I propose per-page CRC32c in a new
BTREE_ID_checksums btree, keyed by (inode, page_offset)
(logical position; reflink interaction is an open question).

Per-page CRCs coexist with whole-extent CRCs during migration.
bch2_checksum_merge() cross-verifies the two — the composition
is mathematically exact. Post-migration, the whole-extent CRC
becomes redundant and can be dropped.

CRC32c computation cost is unchanged — O(n) regardless of page
vs extent granularity. Per-page btree lookups for checksum keys
add overhead that depends on cache residency; with the checksum
btree warm, sequential throughput should be unaffected.

The metadata cost is ~6-8 GiB/TiB including btree key overhead
(~24-32 bytes per key for 256M keys/TiB). This is 64x larger
than the backpointers btree (~4M keys/TiB).

Write-path journal entries are amortized by coalescing. Btree
compaction overhead scales with key count — 64x more keys than
backpointers means proportionally more leaf nodes and
compaction work.

The tradeoff is more btree metadata and per-page insertions on
writes, in exchange for eliminating 64x read amplification on
random reads.

Open questions — feedback welcome on any of these:

1. Metadata overhead: is ~6-8 GiB/TiB of checksum btree
   acceptable? What per-read lookup cost and compaction
   pressure on write-heavy workloads?

2. Amortization on HDD: is the block layer's readahead and
   bio merging sufficient, or does bcachefs need its own
   device-aware batched I/O submission for rotational media?

3. Migration: opt-in or automatic on format upgrade?
   Rate limiting and pause/resume for background checksum
   generation, especially on HDD arrays?

4. Does per-page checksumming reduce or eliminate the need
   for the encoded_extent_max tuning knob?

5. Reflinks: should per-page checksums be keyed by logical
   position (inode, offset) or physical position (device,
   physical_offset)?

6. Per-page compression: which design — dictionary
   separation, trained per-inode dictionaries,
   page-cache-as-dictionary — best fits bcachefs?
