Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F78273D60
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Aug 2025 13:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399406; cv=none; b=m1XqMyQ+FYxP2Mk7GxbjgqIZTu8RAno4pdyWAOughT3KOwrK5edAI0wt/4wDO9l0eErvtZvkY13dCUFuLdX3YSxBwAoU1RITPCTdtAatmo2HgHgSuO9AQEfPQKG6Iip9z7VM9FflZ1UD/BThpV+bruDHrNaxoCqTTIYPEjWlr8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399406; c=relaxed/simple;
	bh=9YWpYPvVuEhAa8l0RhynQKbgmpONs4dDFhykbP7zSEI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=OqxFMYPTxdUTDue/SI9x4kdnuPjc1UUbkPf60RAokRWzdqY698fIuQC0xnjgtL+x3pW0RC8d1zZICfXnA8Kq1ZErMMs+iZyu7vpmv/1rnlI7jPGcRfHyMHpvvuk0KeJN5Kec0t3i+S+fIkBHe21sHhvRSBySdRrXdNMwo91+ke4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8818b1512c2so180910139f.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 05 Aug 2025 06:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754399404; x=1755004204;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/u1raVmfsGzizOARhEi93ynB6XPUBYegU2vD8ceKqEQ=;
        b=EdNgIfTxhyJ+4IUq/ecDLYiSj9gbiXFxjJj4Rbv3Kzv6X3dJTKRrBnnTCc2Q7zhrzL
         maNDBVGTW+FzqR1/yiJTbeobSol1UKbYsJZ+4ztC8Dl9M6VctMRI222OcgAiGDoQMqvX
         zAqg17xyPEb6i1BOjdnrEShkUpOuz2TwNUHMHz8aAxTYnJ0EK7+YxwC7keaEsnU4DGby
         bku55vPFmhEU4ljHEXz3T1ifU542xE2bE21ypxWZldJ/MK1YQZ3I8oevSNr4yI8Vs9kn
         OKbwCxI/MTAvSnWnXIm979xgT8IEgUEChKKoeXiESMtMC2UM2UuIynChhQUKfpThoVoo
         CvNA==
X-Forwarded-Encrypted: i=1; AJvYcCUMGWBfvBEf/oWGFaaO5obLV5HQuN86aUDwU0AMs5WA0cWLtDzPXfg5Uc3vI7XO5J4myOIXZiBXEdcOmfMQ+A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDhvCUJ6V+4QIkfmyd2jhBgBh469KXhe/w2j5xbna3sxYm8Uzy
	WwPJNzvJBfp/pGe52U3WjBvKSZNYKrsVrDs9ppIQEd6BLhIGBOogrMBWIGBTRy/0IbiPwVJaAAm
	lB6gAwVqm8l/NZMfpgBk6kPxTRQadGH7VbhbeFQG0DWHN9xxttzv5+hEpmcg=
X-Google-Smtp-Source: AGHT+IHYI5YJSkaoaN8QBlJToEh4ZCCY9QLRv560/aS/hYDa1iiJPwUbyy9c8Z3Ys9rzoQyR5fPboAJHevQronEdKiM1KXoIf/08
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5d:83d5:0:b0:87c:78b2:6ddb with SMTP id
 ca18e2360f4ac-881683b28aamr2177206939f.9.1754399403991; Tue, 05 Aug 2025
 06:10:03 -0700 (PDT)
Date: Tue, 05 Aug 2025 06:10:03 -0700
In-Reply-To: <419ADDD0-A731-45E5-9B51-DCB2B0CA1717@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689202ab.050a0220.7f033.0022.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in pipe_release (6)
From: syzbot <syzbot+23e4a7772eb9a9715b85@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mmpgouride@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+23e4a7772eb9a9715b85@syzkaller.appspotmail.com
Tested-by: syzbot+23e4a7772eb9a9715b85@syzkaller.appspotmail.com

Tested on:

commit:         5f63c1c6 bcachefs: Fix readahead involved deadlock
git tree:       https://github.com/alanskind/bcachefs
console output: https://syzkaller.appspot.com/x/log.txt?x=1560b6a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8e6834878e5ced02
dashboard link: https://syzkaller.appspot.com/bug?extid=23e4a7772eb9a9715b85
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
