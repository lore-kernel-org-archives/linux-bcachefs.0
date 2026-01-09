Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CE135E556
	for <linux-bcachefs@vger.kernel.org>; Fri,  9 Jan 2026 15:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971926; cv=none; b=m5MzwiyKBHg3Yxq0eo59teBErz5er3lTf7v0KOyouU1K55tHhxnRTTIkt/eVIAB3fm7/AQDEoqjtkchmPocsqj1FSC//66tvGzZZHtuYYkXlkBDyTzECcbl60jj32SdOYXiYaGMHpJXCdRgfM7Z/zumHAY87GS9+tHCOUZpgFD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971926; c=relaxed/simple;
	bh=p738zlUiP8gQXhOeh60EYYG9PIwZEAK4hGMEro8yAqY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=Ke3qR0wzxNDRVzXakItA/sQpGyTSIVoYcDMIUeXpJkYSdHTVsWT/i0PA70dgjatnaLiVVskcjxT+AONwy0ByLJIeOjcfsapVGRY+bJyshoG2QWdJ2QJv0qSFM4f5Ye1/aIXAO4WYHU1/zwzCcNg3DQr4AiYu4xTObEHaKYSLP3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 1AE781003E11EA; Fri,  9 Jan 2026 16:10:22 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 18EE011009D12A
	for <linux-bcachefs@vger.kernel.org>; Fri,  9 Jan 2026 16:10:22 +0100 (CET)
Date: Fri, 9 Jan 2026 16:10:22 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: linux-bcachefs@vger.kernel.org
Subject: `bcachefs fs usage` is missing some spaces
Message-ID: <8sq99o96-0755-r095-o410-o6n1o4oq228s@vanv.qr>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


Kernel component: 1.33.4
Userspace component: 1.34.0 (also with 1.33.4)

```
# bcachefs fs usage /var/lib/lancache
Filesystem: c5ac2bf7-79a9-484d-8886-5188cb3168e7
Size:                  5549130619392
Used:                  2488634602496
Online reserved:           114860032

Data by durability desired and amount degraded:
          undegraded
1x:    2467920244736
2x:      20597702656

Device label                   Device      State          Size      Used  Use%
hdd.hdd0 (device 2):           sde         rw      10002030919687816089600 00%
hdd.hdd1 (device 3):           sdf         rw      10002030919687816089600 00%
ssd.ssd0 (device 0):           sdd         rw      96019572326463255844454465%
ssd.ssd1 (device 1):           sda         rw      96019572326463252830208065%
ssd.ssd2 (device 4):           sdh         rw      96019572326463251319603265%
ssd.ssd3 (device 6):           sdb         rw      96019677184062093350912064%
```

There are some spaces missing in the output. It is not readable this way.

# blockdev --getsize64 /dev/sde: 1000204886016
# blockdev --getsize64 /dev/sdb: 960197124096

So that's what the number should be close to.
