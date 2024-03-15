Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3231772D
	for <linux-bcachefs@vger.kernel.org>; Fri, 15 Mar 2024 04:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710477676; cv=none; b=OPJs/8d1nrS7qq9Fby69wVmG0Ii9uOy0wHKVQEhkrWhxQ09Wap1+B2UtKgOHdPxxjuRqMDtjssCD+1MuK/6Bjt/BDXafPyxfsPM+OBx+nfBPFTyA7C/E881lCjYBIATP7xb2rxHqBilrijBKss/glzCFuH8LS/ADmvgSIWBVtzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710477676; c=relaxed/simple;
	bh=X556mm4b3NpKRrUCJb6n7/rhicann9OZN87sidxesuU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fqMi7Pi++8GV3a4gAJwnHEzrxxSjTqSV5irJaSbIEcMyD+3k1YfTiMa5yGgUE1+DEkqQhNRtWWZU5RKr8+EiSAAcEglxF9m6NrBA/jdgRTAhuzd0m+3xrhtXOcIs2HsnnJhvkU+XZSQC6t/8zzk12Mq9F9vWy89e0TtaPK9/rFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YmBtz8zp; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YmBtz8zp"
Date: Fri, 15 Mar 2024 00:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710477673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=FxktxHvBJyfDKoa1bxvzSlyMzdw19RWnlTREhjaJS9A=;
	b=YmBtz8zpXZ3X+nN6YK1MiC/nghiJLmLfgbN0gAzP5k7RRB9MCJuXxPZNTGoGZLmRPiIzjy
	gdrjstZP82IJC6uwwEEHfIP7wcKCLa93wmUwvVxMU3vsknpQBAPsk/qdr1aLM5Oaf6Phwv
	iP/HDBDBGrpckvVlFY7kwdG3/hBWyNI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: bcachefs: do not run 6.7: upgrade to 6.8 immediately if you have a
 multi device fs
Message-ID: <muwlfryvafsskt2l2hgv3szwzjfn7cswmmnoka6zlpz2bxj6lh@ugceww4kv3jr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

there's a bug in 6.7 with filesystems that are mid upgrade and then get
downgraded not getting marked in the superblock as downgraded, and this
translates to a really horrific bug in splitbrain detection when the old
version isn't updating member sequence nmubers and you go back to the
new version - this results in every device being kicked out of the fs.

and our backports are not being picked up by the stable team, so - do
not run 6.7, switch to 6.8 immediately, running 6.7 with new -tools will
trigger it.

if you are affected:

 - 6.9 (once Linus merges) will have a new no_splitbrain_check option,
   which runs the splitbrain checks in dry mode and won't kick your
   devices out

 - we have new repair code landing soon that can recover from
   missing/unreadable btree roots by scanning the entire device(s) for
   btree nodes (which, fortunately, we have sufficient metadata in btree
   node headers to do safely; reiserfs famously did not). i've seen some
   crazy corruption resulting from this, but it might still be
   recoverable
