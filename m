Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDE11A3A91
	for <linux-bcachefs@vger.kernel.org>; Wed, 25 Sep 2024 23:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727307550; cv=none; b=kzADZs9jv2Jxx1wPPqlEPmE4Av6rGpMwEeIdlkxyHRKh93c8a05xi7TjFceEx486iyDxNgtxs4mVWlEkXapoANZN0McQBM030k8KktwIqEkggabkE+4iD1AyWftjgIw1IEuyJ7LeW12ov9PlBPN3taQZhRqPRwcgjAdeBCo9A2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727307550; c=relaxed/simple;
	bh=YnBRScfMxECYFwErmC+hQ3vY5SfaYLaNykQnVElJgl4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=psINGkpHdqj1c8D8MZ63HDeFFDtsZNtJJYXa9fiDiOlftJ7Dch7TCpNnNF//ftGbA4AgvdZHiQGgQtVcqEkq3xacFW1pXBBTXjPGC/AY6kqOPv529dAILdw1zqfOdMWjNuRyG8EIUf60bcEJfnXh/iFdNBcbi4l2Lg+6RIUDNec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O4BmQFRS; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O4BmQFRS"
Date: Wed, 25 Sep 2024 19:38:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727307546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=YnBRScfMxECYFwErmC+hQ3vY5SfaYLaNykQnVElJgl4=;
	b=O4BmQFRS3iv2I3JbrFNo1S+D9z9J/yMUgTBnLDAQnqytVZfGvfN2WiD5tvMzSF3QcHk5oG
	GDRWpEWtndzwIgKzhz04IUiPgM9uzKj5P8tpLJjbF+HdV/FGX7QYk85RDJ/6A57QDijGnc
	r5oCMmMG/ulaIXuyQ0WWFxqPxOOmtUE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Subject: (return of) Weekly bcachefs cabal
Message-ID: <3x5h732as5uumcon22qbdj7jolvtuya5w4rt4dqwtrmi37edwg@emugpobtrp36>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Things are picking up, so I'm resuming weekly bcachefs meeting:; the new
time is noon EST, Tuesdays as before.

Bit early for pacific coast folks (like me at the moment), but should be
easier for folks in Europe and China.

Shoot me an email for an invite.

Cheers,
Kent
