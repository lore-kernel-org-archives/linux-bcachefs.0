Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cZN+MycV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="m4QvHhFY";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cZN+MycV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="m4QvHhFY"
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B7B10E3;
	Thu,  7 Dec 2023 11:40:36 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 267CE1F750;
	Thu,  7 Dec 2023 19:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1701978035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NJNd7NoZJyzTww1mqoSz00tSROp7biBBjkoSRXyiXnw=;
	b=cZN+MycVqAxk8FfOMw3qAtRlNhhKuPGHYEUFXu2oMDDRGUIeR5uqkFMop3dTHIrisX/bKd
	mgxfuNRvjJSLIE31MgHekdMF+y2DkN5+altI4iu8nrTtKkajM70WwY+73AXvzoHamhVyn1
	1mJB0xmudkwnu8rLZfB6mJ9mPAxFQJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1701978035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NJNd7NoZJyzTww1mqoSz00tSROp7biBBjkoSRXyiXnw=;
	b=m4QvHhFYO4NRoJdJl/MHph0YMhOXJJFjEuQtxHhehIMRqA/d6aHKxXoEyL4bMwWyB7mP8H
	pcIS2yvhaus37EBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1701978035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NJNd7NoZJyzTww1mqoSz00tSROp7biBBjkoSRXyiXnw=;
	b=cZN+MycVqAxk8FfOMw3qAtRlNhhKuPGHYEUFXu2oMDDRGUIeR5uqkFMop3dTHIrisX/bKd
	mgxfuNRvjJSLIE31MgHekdMF+y2DkN5+altI4iu8nrTtKkajM70WwY+73AXvzoHamhVyn1
	1mJB0xmudkwnu8rLZfB6mJ9mPAxFQJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1701978035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NJNd7NoZJyzTww1mqoSz00tSROp7biBBjkoSRXyiXnw=;
	b=m4QvHhFYO4NRoJdJl/MHph0YMhOXJJFjEuQtxHhehIMRqA/d6aHKxXoEyL4bMwWyB7mP8H
	pcIS2yvhaus37EBQ==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 760BF13907;
	Thu,  7 Dec 2023 19:40:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id xfK2GLIfcmVyBQAAn2gu4w
	(envelope-from <pvorel@suse.cz>); Thu, 07 Dec 2023 19:40:34 +0000
From: Petr Vorel <pvorel@suse.cz>
To: ltp@lists.linux.it
Cc: Petr Vorel <pvorel@suse.cz>,
	Cyril Hrubis <chrubis@suse.cz>,
	Li Wang <liwang@redhat.com>,
	Richard Palethorpe <rpalethorpe@suse.com>,
	Jan Stancek <jstancek@redhat.com>,
	Xiao Yang <yangx.jy@fujitsu.com>,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	fstests@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 0/3] Add support bcachefs filesystem
Date: Thu,  7 Dec 2023 20:40:08 +0100
Message-ID: <20231207194011.273027-1-pvorel@suse.cz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: 4.83
X-Spam-Flag: NO
X-Spamd-Result: default: False [4.84 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[14];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[suse.cz,redhat.com,suse.com,fujitsu.com,linux.dev,vger.kernel.org,gmail.com];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.06)[61.54%]
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Score: 4.84

Hi all,

@Amir @Jan, could you please have look on fanotify failures on Bcachefs?
fanotify13.c, fanotify15.c and fanotify16.c produce many errors.

To test, just apply this patchset and then run with LTP_SINGLE_FS_TYPE:

# LTP_SINGLE_FS_TYPE=bcachefs ./fanotify15

changes v1->v2:
Two new commits:
* lib: Add Bcachefs magic
* statx04: Skip STATX_ATTR_COMPRESSED on Bcachefs

Petr Vorel (3):
  lib: Add Bcachefs magic
  lib: Add support bcachefs filesystem to .all_filesystems
  statx04: Skip STATX_ATTR_COMPRESSED on Bcachefs

 include/tst_fs.h                          | 3 +++
 lib/tst_fs_type.c                         | 2 ++
 lib/tst_supported_fs_types.c              | 2 ++
 testcases/kernel/syscalls/statx/statx04.c | 5 +++--
 4 files changed, 10 insertions(+), 2 deletions(-)

-- 
2.43.0

