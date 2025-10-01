Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028A02D9ED7
	for <linux-bcachefs@vger.kernel.org>; Wed,  1 Oct 2025 09:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759311429; cv=none; b=uM77fOhHA5cJXSct5LnMvTmy2+AZyctYSh6hWc9oS+/TQkPC0TEbjCPE//qeL7u2J9GVzJ2srV0z4bPeOD820lkkEiCdffZf9axa9XdrPDDwh2Mb5vUmI1ASUfXZmqlBZoA1iu+PJnn32kBapIQKVpYxGiDmv7xMgNUfgaffyJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759311429; c=relaxed/simple;
	bh=smJzPZ2H+puqNQpL9LTWdRgBhAS8OfsmNfjleezYjpM=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=bEGA9CrAHQ7S9eupVyg0QnCOUQ/jqJaPfAVjz6TGQJWgFjxDwj/FaUMcH+EtOUhXwVPnrRbx4ajprnYt3T/UY34lmHde8dMZGeNPK+FZJy7iFgf/yrfip/4iPkAucTwIjBPPeqMCKrNbcHkh4WNWhC/BhtcFLLU02KR/6CUiQVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bo9GNEPo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bo9GNEPo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759311426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=00w3hkHfsTAxYQCvIOKAjdtuK2kAChIoMSa2X5uPZB0=;
	b=bo9GNEPoE91+HKTuki3uh6rvH3rOLqGRbjajgJc3dyyQQziSupCLa91JJJmvnHaKdE/Qdi
	r92XrQih1RA6yuCtjluOoxKY59FrRJWKkI6RUyg0picUhHzJsoLtBoAHmkQwduWQ4t3/Md
	AB1SUhNU9IuXvM9Ditw9apNnIIMC57o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-ngBKf_HyMku4dc3tcFSEpA-1; Wed,
 01 Oct 2025 05:37:01 -0400
X-MC-Unique: ngBKf_HyMku4dc3tcFSEpA-1
X-Mimecast-MFC-AGG-ID: ngBKf_HyMku4dc3tcFSEpA_1759311419
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0BBC1800451;
	Wed,  1 Oct 2025 09:36:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 003CB30002C5;
	Wed,  1 Oct 2025 09:36:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251001083931.44528-1-bhanuseshukumar@gmail.com>
References: <20251001083931.44528-1-bhanuseshukumar@gmail.com>
To: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
Cc: dhowells@redhat.com, Kent Overstreet <kent.overstreet@linux.dev>,
    Jonathan Corbet <corbet@lwn.net>, Carlos Maiolino <cem@kernel.org>,
    Paulo Alcantara <pc@manguebit.org>,
    Alexander Viro <viro@zeniv.linux.org.uk>,
    Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
    linux-bcachefs@vger.kernel.org, linux-doc@vger.kernel.org,
    linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-kernel-mentees@lists.linuxfoundation.org,
    skhan@linuxfoundation.org, david.hunter.linux@gmail.com
Subject: Re: [PATCH] fs: doc: Fix typos
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2077277.1759311412.1@warthog.procyon.org.uk>
Date: Wed, 01 Oct 2025 10:36:52 +0100
Message-ID: <2077278.1759311412@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com> wrote:

> Fix typos in doc comments
> 
> Signed-off-by: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>

Reviewed-by: David Howells <dhowells@redhat.com>

