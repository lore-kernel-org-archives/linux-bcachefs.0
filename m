Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC6526ACB
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Sep 2025 00:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.77.7.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758848148; cv=none; b=oGn0QNp33n9WTfO56wAuUFgmupwpCVFOWylYDcbQ4eYcK+f0Hq86UPJr1rvG+dvEDKDcdGVI68bVFBUSRUKQC3fJ+Yixa8wXSPnjYsBTtQl97AoCGK7P1Wh+7n0EYCuZGYYFgO1in71CgFrPt4MI1I3WTSMJ+qcqCmIHpyfulR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758848148; c=relaxed/simple;
	bh=EawkUdJ1uji+Nu7Sui396x2CPmWTMgQfHfQy2dsEdis=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=dTPsY/HmyM9bUkaq6rA7+JyuwEjhbGsPtEynDKU912ZDaHRtYdrYm6MH6r7v5KfJK5Vhq3tvZv9kQHb7kCuxAWcKe2y5t/p96QUedvtbnPc0L/oSwmj4OSZX+9nGr//ZUhg3HEQkLhv0PROVVgr6wAB8thoNwef8GmvK1OM9A8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net; spf=pass smtp.mailfrom=carlthompson.net; arc=none smtp.client-ip=45.77.7.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id 62F421E3AE32F
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 17:50:01 -0700 (PDT)
Date: Thu, 25 Sep 2025 17:50:01 -0700 (PDT)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <1533207458.2489.1758847801248@mail.carlthompson.net>
Subject: Strange directory hierarchy in bcachefs DKMS packages
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev73
X-Originating-Client: open-xchange-appsuite

Hello,

The bcachefs DKMS packages from apt.bcachefs.org have a non-standard directory hierarchy that can cause problems. Instead of putting the source files directly in the DKMS source directory the packages use a "src/fs/bcachefs" subdirectory. This causes an issue when the module is installed using the standard kernel method like this:

     INSTALL_MOD_PATH=$(realpath "$WORK") INSTALL_MOD_DIR="dkms" \
          make -C "$hdir/" M="$sdir/" MO="$mdir/" modules_install
     
This causes the module to be installed at a nonstandard and unexpected path like this:

     /lib/modules/6.16.9-0-stable/dkms/src/fs/bcachefs/bcachefs.ko.gz

But it is expected that the module would be installed here:

     /lib/modules/6.16.9-0-stable/dkms/bcachefs.ko.gz

The problematic path may still work in some circumstances particularly when "modprobe" is used but may fail if "insmod" is used directly with the expected path.

I'm using the 1.31.3 version from apt.bcachefs.org. I downloaded the Arch DKMS package too and it has the same problem too.

Thanks,
Carl
