Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C6623AE
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Dec 2023 11:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 464B285AD37;
	Sat, 30 Dec 2023 12:00:16 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Testing xxhash
Date: Sat, 30 Dec 2023 12:00:15 +0100
Message-ID: <1885915.tdWV9SEqCh@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Kent, hi everyone,

While still evaluating BCacheFS I thought I could give xxhash checksumming 
a try:

  metadata_checksum:                        none crc32c crc64 [xxhash] 
  data_checksum:                            none crc32c crc64 [xxhash] 
  compression:                              lz4
  background_compression:                   none
  str_hash:                                 crc32c crc64 [siphash] 

Anything to watch out for? So far everything seems to work just fine.

As for now no scrubbing available or is there? Does BCacheFS verify 
checksums on reads?

I am still not sure whether anything more than crc32c is really needed. 
But on the other hand even with already a bit older processors like AMD 
Ryzen 4750U with 8 cores I bet checksumming with xxhash should not be CPU 
bound. Actually on devices with fast enough devices I use xxhash with 
BTRFS since more than a year already and scrubbing goes between 1,6 and 
2,6 GiB/s with NVME SSDs. And regarding hash collisions I'd rather be safe 
than sorry.

Best,
-- 
Martin


