Received: from server.roznica.com.ua (server.roznica.com.ua [80.90.224.56])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAA2E11716
	for <linux-bcachefs@vger.kernel.org>; Fri, 23 Feb 2024 05:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.90.224.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708665957; cv=none; b=JsdsTyOZ/ivv5dwLi5TC0T5Hhc6+a99J+0hgz0UrUvpxL27kFs1AF4ue4U26ubAQjbw6Um8PH+C5Nye3zgPnh0Nmig4xxEmshSoGm+HY5tU0lyu80EordD0bJkTMAgWJ3/uNfRJ1KdLBKgxP+lzP9h8mlpIKeChsPbpBtwXUGJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708665957; c=relaxed/simple;
	bh=emdx/nX/JMtn83yHXY2DpszWT0c1fKfopHtk++xCAEs=;
	h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type; b=s5TMGrRIYUJuDTzWKQdJEUMRtTYoZIUa+pGfZ9iNFgHhb4D1BkJSDf0IyQw2hazbBvNwdbe9GK4GLeaw5vfMj/iSF7ekzvE9TOSP+BhAtwx7UwAXdRTwq7JNF4l/X+Z2oaHv1XWHZ3cq4KSa0IQHHkiLC/JvOrQVuuZZiR82m/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roznica.com.ua; spf=pass smtp.mailfrom=roznica.com.ua; arc=none smtp.client-ip=80.90.224.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roznica.com.ua
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=roznica.com.ua
Received: from work.roznica.com.ua (188-115-152-42.broadband.tenet.odessa.ua [188.115.152.42])
	by server.roznica.com.ua (Postfix) with ESMTP id DF42B98501C
	for <linux-bcachefs@vger.kernel.org>; Fri, 23 Feb 2024 07:25:50 +0200 (EET)
To: linux-bcachefs@vger.kernel.org
From: Michael <mclaud@roznica.com.ua>
Subject: filefrag output
Message-ID: <ae2f2b23-da68-219c-1080-081ffe64ca9d@roznica.com.ua>
Date: Fri, 23 Feb 2024 07:25:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US

Can't find any information about

Are duplicates of logical extent offsets different replicas?
Are the replicas listed always sorted by number (first, second, third, 
...) or in random order?
Where "replica 2" offset 448k ?
Is the physical offset the offset on the device? Which device id?

Example:
dd if=/dev/random of=tst.dat bs=512k count=1

filefrag -v -b1024 tst.dat output:
Filesystem type is: ca451a4e
File size of tst.dat is 524288 (512 blocks of 1024 bytes)
  ext:     logical_offset:        physical_offset: length: expected: flags:
    0:        0..      63:   11856128..  11856191: 64:             encoded
    1:        0..      63:   16075264..  16075327: 64:             encoded
    2:       64..     127:   11856192..  11856255:     64: 16075328: encoded
    3:       64..     127:   16075328..  16075391:     64: 11856192: encoded
    4:      128..     191:   11856256..  11856319:     64: 16075392: encoded
    5:      128..     191:   16075392..  16075455:     64: 11856256: encoded
    6:      192..     255:   11856320..  11856383:     64: 16075456: encoded
    7:      192..     255:   16075456..  16075519:     64: 11856320: encoded
    8:      256..     319:   13653248..  13653311:     64: 16075520: encoded
    9:      256..     319:   16383488..  16383551:     64: 13653248: encoded
   10:      320..     383:   13653312..  13653375:     64: 16383552: encoded
   11:      320..     383:   16383552..  16383615:     64: 13653312: encoded
   12:      384..     447:   13653376..  13653439:     64: 16383616: encoded
   13:      384..     447:   16383616..  16383679:     64: 13653376: encoded
   14:      448..     511:   13653440..  13653503:     64: 16383680: 
last,encoded,eof
tst.dat: 14 extents found


-- 
Michael

